package net.bigpoint.as3toolbox.filecollection.vo
{
   public class UrlFileVO extends FileVO
   {
      
      private var _url:String;
      
      public function UrlFileVO(param1:String, param2:String, param3:String, param4:String)
      {
         super(param1,new LocationVO("urlFile",""),param2,param3,"",null);
         this._url = param4;
      }
      
      override public function getFileName(param1:Boolean = false) : String
      {
         return this._url;
      }
   }
}

