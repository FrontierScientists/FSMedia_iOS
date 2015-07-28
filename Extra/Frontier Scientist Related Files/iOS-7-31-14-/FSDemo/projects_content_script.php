// projects_content_script.php
//
// Aaron Andrews
// 6/13/14
// This script will take a string and a file as parameters. It will look through the string for the substring "[ video ]" and put all text up to that substring into the file
// Example input: php projects_content_script.php "It works1[ video ] cutoff" "/Users/alandrews3/Desktop/outputFile.txt"
// Example output in /Users/alandrews3/Desktop/outputFile.txt: "It works1"

<?php

    $arr1 = str_split($argv[1]);
    $newStr = "";
    $checkStr = "";
    $switch = 0;
    
    foreach($arr1 as $value)
    {
        if ($value == "[")
        {
            if($switch == 0) //In case an '[' is encountered after the first one
            {
                $switch = 1;
            }
            else
            {
                $switch = 1;
                $newStr = $newStr . $checkStr;
                $checkStr = "";
            }
        }
        
        if($switch > 0)
        {
            $checkStr = $checkStr . $value;
            ++$switch;
            
            if($switch > 9) //We will have "[ video ]" or a deadend
            {
                if($checkStr == "[ video ]") //Found "[ video ]", write string to file and exit
                {
                    file_put_contents($argv[2], $newStr, FILE_APPEND);
                    file_put_contents($argv[2], "\n", FILE_APPEND);
                    exit;
                }
                else // '[' did not result in "[ video ]", append checkStr to newStr and contiue
                {
                    $switch = 0;
                    $newStr = $newStr . $checkStr;
                    $checkStr = "";
                }
            }
        }
        else
            $newStr = $newStr . $value;
    }
    file_put_contents($argv[2], $newStr, FILE_APPEND);
    file_put_contents($argv[2], $checkStr, FILE_APPEND);
    file_put_contents($argv[2], "\n", FILE_APPEND);
    ?>
