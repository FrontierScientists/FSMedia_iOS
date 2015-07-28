<?php
    //Created by Andrew S. Clark
    //6/16/14
    //A PHP script that connects to the MySQL server that has the data for the Fontier Scientists, performs a SELECT query to get relevant information for the app (research related info and videos), and writes it to an XML file.  The XML file is fetched by the iOS app, parsed, and used to populate the app with data about various research.
    
    //***THESE VARIABLES WILL NEED TO BE INITIALIZED WITH DIFFERENT DATA ONCE THE SERVER ON THE VM IS SET UP ***
	$dbhost = "127.0.0.1";
	$dbuser = "user";
	$dbpass = "mysqlpass";
	$dbname = "frontsci";
    //********************************
    
	$connection = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);
	
	if(mysqli_connect_errno())
	{
		die("Database connection failed: " .
			 mysqli_connect_error() .
			 " ( " . mysqli_connect_errno() . ")"
			);
	}

	$projectsQuery = "SELECT wp_posts.post_type,wp_terms.name,wp_posts.post_title,wp_posts.post_content ";
	$projectsQuery .= "FROM wp_term_relationships, wp_posts, wp_terms, wp_term_taxonomy ";
	$projectsQuery .= "WHERE wp_term_relationships.object_id=wp_posts.ID ";
	$projectsQuery .= "AND (wp_posts.post_type=\"projects\" OR  wp_posts.post_type=\"videos\") ";
	$projectsQuery .= "AND wp_term_relationships.term_taxonomy_id=wp_term_taxonomy.term_taxonomy_id ";
	$projectsQuery .= "AND wp_term_taxonomy.term_id=wp_terms.term_id ";
	$projectsQuery .= "ORDER BY name ASC";

	$result = mysqli_query($connection, $projectsQuery);
	
	if(!$result)
	{
		die("Database query failed.");
	}

	$File = "dumpedSelectQuery.xml";
 	$Handle = fopen($File, 'w');
	
	$Data = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    fwrite($Handle, $Data);
	$Data = "<research>\n";
	fwrite($Handle, $Data);
	
	foreach($result as $row)
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

	
	$Data = "</research>\n";
	fwrite($Handle, $Data);
	
	fclose($Handle);
	mysqli_free_result($result);

mysqli_close($connection);
?>
