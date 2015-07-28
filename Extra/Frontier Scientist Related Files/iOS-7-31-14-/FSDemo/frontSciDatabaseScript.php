<?php

// Created by Andrew S. Clark
// 6/17/14
// A PHP script to 1) clone Frontier Scientist database from Git, 2) merge the database dump into 1 file for easy import, 3) import it with default encdoing set to UTF-8, 4) perform a SELECT query, and write the result to an XML file for the app to parse
 
	# 1) Git Clone - clone to /tmp
   $gitDir = "/tmp/frontiersci3";

   if(is_dir($gitDir))
   {
		echo "Deleting folder, starting clone.\n";
      shell_exec("rm -Rf " . $gitDir);
      if( (exec("git clone https://onudson:frontsci.arsc.edu9@bitbucket.org/alpine/frontiersci3.git /tmp/frontiersci3")) != 0)
		{
			exit("The Git clone failed.");
		}
   }
	else 
	{
		echo "Folder doesn't exits, starting clone.\n";
		if( (exec("git clone https://onudson:frontsci.arsc.edu9@bitbucket.org/alpine/frontiersci3.git /tmp/frontiersci3")) != 0)
		{
			exit("The Git clone failed.");
		}
   }

	# 2) Merge - after successful Git clone, merge all the .sql files into one file to import into database
   $mergedFile = "/tmp/frontiersci3/db/mergedSQLFilesForImport.sql";
	
	if(file_exists($mergedFile))
	{
		echo "Deleting " . $mergedFile . ".\n";
		shell_exec("rm " . $mergedFile);
	}
 	
   $Handle = fopen($mergedFile, 'w');

	echo "Starting merge of files.\n";

   foreach (glob("/tmp/frontiersci3/db/*.sql") as $filename) 
   {
      $fileContents = file_get_contents($filename);
      fwrite($Handle, $fileContents);
   }

   fclose($Handle);
	
	# 3) Import Database
   $dbhost = "localhost";
   $dbuser = "asclark";
   $dbpass = "mysqlpass";
   $dbname = "frontierscientists";

   $connection = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);

   if(mysqli_connect_errno())
   {
      exit("Database connection failed: " .
           mysqli_connect_error() .
           " ( " . mysqli_connect_errno() . ")"
         );
   }
	
	$mysqlImportCmd = "mysql -u 'asclark' -p'mysqlpass' --default_character_set=utf8 frontierscientists < /tmp/frontiersci3/db/mergedSQLFilesForImport.sql";
	echo "Importing database.\n";

   shell_exec($mysqlImportCmd);

	#4) Perfom SELECT and write result to XML file
	$projectsQuery = "SELECT wp_posts.post_type,wp_terms.name,wp_posts.post_title,wp_posts.post_content ";
	$projectsQuery .= "FROM wp_term_relationships, wp_posts, wp_terms, wp_term_taxonomy ";
	$projectsQuery .= "WHERE wp_term_relationships.object_id=wp_posts.ID ";
	$projectsQuery .= "AND (wp_posts.post_type=\"projects\" OR  wp_posts.post_type=\"videos\") ";
	$projectsQuery .= "AND wp_term_relationships.term_taxonomy_id=wp_term_taxonomy.term_taxonomy_id ";
	$projectsQuery .= "AND wp_term_taxonomy.term_id=wp_terms.term_id ";
	$projectsQuery .= "ORDER BY name ASC";

	echo "Performing SELECT query.\n";

	$result = mysqli_query($connection, $projectsQuery);
	
	if( ($result == false) OR (mysqli_num_rows($result) == 0) )
	{
		exit("Database SELECT query failed.\n");
	}

	$dumpedSelectQuery = "/tmp/frontiersci3/db/dumpedSelectQuery.xml";
	
	if(file_exists($dumpedSelectQuery))
	{
		shell_exec("rm " . $dumpedSelectQuery);
	}
 	
	echo "Starting dump to XML file.\n";

	$Handle = fopen($dumpedSelectQuery, 'w');

	$Data = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
   fwrite($Handle, $Data);
	$Data = "<research>\n";
	fwrite($Handle, $Data);
	$closingTag = "";

	while ($row = mysqli_fetch_assoc($result))
	{
			$Data = "\t<topics>\n";
			fwrite($Handle, $Data);

		foreach($row as $key => $value)
		{			
			if($key == 'post_type' AND $value == 'videos')
			{
				$closingTag = $value;

				$Data = "\t\t<$value>\n";
				fwrite($Handle, $Data);

         	$Data = "\t\t\t<" . $key . ">";
            fwrite($Handle, $Data);
            
            $Data = $value;
            fwrite($Handle, $Data);	
         	
         	$Data = "</" . $key . ">\n";
            fwrite($Handle, $Data);	
			}
			else if($key == 'post_type' AND $value == 'projects')
			{
				$closingTag = $value;

				$Data = "\t\t<$value>\n";
            fwrite($Handle, $Data);

         	$Data = "\t\t\t<" . $key . ">";
            fwrite($Handle, $Data);
            
            $Data = $value;
            fwrite($Handle, $Data);	
         	
         	$Data = "</" . $key . ">\n";
            fwrite($Handle, $Data);	
			}
			else
			{
         	$Data = "\t\t\t<" . $key . ">";
            fwrite($Handle, $Data);
            
            $Data = $value;
            fwrite($Handle, $Data);	
         	
         	$Data = "</" . $key . ">\n";
            fwrite($Handle, $Data);
				
			}
		}

		$Data = "\t\t</$closingTag>\n";
		fwrite($Handle, $Data);
		
		$Data = "\t</topics>\n\n";
		fwrite($Handle, $Data);
	}

	
	$Data = "<research>\n";
	fwrite($Handle, $Data);
	
	echo "Finshed dump to XMl, closing files and connection.\n";
	
	fclose($Handle);
	mysqli_free_result($result);

	mysqli_close($connection);
?>
