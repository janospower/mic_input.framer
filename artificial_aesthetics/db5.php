<!DOCTYPE html>
<html>
 <head>
   <meta charset="utf-8">
   <title>DB</title>
   <script src="js/aframe/aframe.js"></script>
 </head>
 <body>
     <?php
     echo '<a-scene>
            <a-entity light="type: directional; color: yellow; intensity: 0.7" position="-0.5 1 1"></a-entity>
            <a-entity light="type: directional; color: blue; intensity: 0.5" position="-5 -1 -1"></a-entity>';

       // Database Connection

       $pdo = new PDO('mysql:host=localhost:8889;dbname=sun180413', 'root', 'root');
       $sql = 'SELECT Filename, LikesCount, CommentsCount, Caption, Username FROM Sun';

       // read data

       foreach ($pdo->query($sql) as $row) {

         $Var01 = $row['LikesCount'] * 0.2;
         $Var02 = $row['CommentsCount'] * 0.2;
         $Var03 = $row['LikesCount'] * $row['LikesCount'] * 0.2;
         $Vimage01 = 'db/sun/'.$row['Filename'];

         // write data

         if($Var01 > 0 and $Var02 > 0) {
           echo "<a-box
                    src='".$Vimage01."'
                    position='".$Var01." ".$Var03." -3'
                    scale='".$Var01." ".$Var02." ".$Var03."'
                    rotation='0 ".$Var02." 0'
                    color='hsl(".($i * 100).", 100%, 50%)'
                  ></a-box>";

           $i++;
         };

         // stop after X loops

         if( $i == 10 ) {
           break;
         }
       };
       echo '<a-sky color="black"></a-sky>
     </a-scene>';

      ?>
 </body>
</html>
