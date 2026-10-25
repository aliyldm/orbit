package net.bigpoint.as3toolbox.filecollection.finish
{
   import com.adobe.serialization.json.JSON;
   import net.bigpoint.as3toolbox.filecollection.vo.FileVO;
   
   public class JSONFinisher extends FileCollectionFinisher
   {
      
      public function JSONFinisher()
      {
         super();
      }
      
      override public function start(param1:FileVO) : void
      {
         super.start(param1);
         finish();
      }
      
      public function getJSON() : Object
      {
         return com.adobe.serialization.json.JSON.decode(fileVO.getData(),false);
      }
   }
}

