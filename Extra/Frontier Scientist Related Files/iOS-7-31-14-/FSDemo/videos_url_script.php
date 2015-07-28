<?php
    $str = "FrontierScientists video Paleo-Eskimo Across The Arctic In An Archaeological Instant&lt;iframe src=&quot;http://www.youtube.com/embed/GdPkFgvU6Jk&quot; height=&quot;315&quot; width=&quot;560&quot; frameborder=&quot;0&quot;&gt;&lt;/iframe&gt;&lt;h1&gt;Across The Arctic In An Archaeological Instant&lt;/h1&gt;Uncovering a Paleo Eskimo Camp.Andrew Tremayne and Jeff Rasic discuss the Denbigh small tool tradition and how it seems it spread across the arctic.project &lt;a title=&quot;Paleo-Eskimo&quot; href=&quot;http://frontierscientists.com/projects/project-paleo-eskimo/&quot;&gt;Paleo-Eskimo&lt;/a&gt;Embed Code:&amp;lt;iframe width=&quot;560&quot; height=&quot;315&quot; src=&quot;http://www.youtube.com/embed/GdPkFgvU6Jk&quot; frameborder=&quot;0&quot; allowfullscreen&amp;gt;&amp;lt;/iframe&amp;gt;";
    
    $dec = htmlspecialchars_decode($str);
    $arr1 = str_split($dec);
    $newStr = "";
    $checkStr = "";
    $switch = 0;
    $foundURL = 0;
    
    
    foreach($arr1 as $value)
    {
        if ($value == "<" && $switch == 0)
        {
            $switch = 1;
            $checkStr = "";
        }
        
        elseif($switch > 0)
        {
            $checkStr = $checkStr . $value;
            ++$switch;
            
            if($switch > 12) //We will have: iframe src=" or a deadend
            {
                if($checkStr == "iframe src=\"") //Found: iframe src="
                {
                    $foundURL = 1;
                }
                $switch = 0;
            }
        }
        elseif($foundURL == 1)
        {
            if($value == "\"")
            {
                file_put_contents($argv[2], $newStr, FILE_APPEND);
                exit;
            }
            $newStr = $newStr . $value;
        }
    }
    // This only happens if a video url is never found, tempting to just put the link to the rick-roll video...
    file_put_contents($argv[2], "video not found\n", FILE_APPEND);
?>
