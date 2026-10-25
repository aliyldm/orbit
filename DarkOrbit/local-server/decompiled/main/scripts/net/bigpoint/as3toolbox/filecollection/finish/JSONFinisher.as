package net.bigpoint.as3toolbox.filecollection.finish
{
   import com.adobe.serialization.json.JSON;
   
   public class JSONFinisher extends FileCollectionFinisher
   {
      
      public function JSONFinisher()
      {
         super();
      }
      
      public function getJSON() : Object
      {
         return com.adobe.serialization.json.JSON.decode(_data,false);
      }
   }
}

