package net.bigpoint.darkorbit.map.view3D.loaders
{
   import away3d.arcane;
   import away3d.loaders.misc.ResourceDependency;
   import away3d.loaders.parsers.ParserBase;
   import deng.fzip.FZip;
   import deng.fzip.FZipEvent;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   use namespace arcane;
   
   public class ZIPParser extends ParserBase
   {
      
      private var file:FZip;
      
      public function ZIPParser()
      {
         super(URLLoaderDataFormat.BINARY);
      }
      
      public static function supportsType(param1:String) : Boolean
      {
         return param1.toLowerCase() == "zip";
      }
      
      public static function supportsData(param1:*) : Boolean
      {
         return false;
      }
      
      override protected function proceedParsing() : Boolean
      {
         if(this.file == null)
         {
            this.file = new FZip();
            this.file.addEventListener(FZipEvent.FILE_LOADED,this.handleContentFileLoaded);
            this.file.debug = _fileName;
            this.file.loadBytes(_data);
         }
         if(parsingPaused)
         {
            return MORE_TO_PARSE;
         }
         return PARSING_DONE;
      }
      
      override arcane function resolveDependency(param1:ResourceDependency) : void
      {
         var _loc2_:* = int(param1.assets.length - 1);
         while(_loc2_ >= 0)
         {
            finalizeAsset(param1.assets[_loc2_]);
            _loc2_--;
         }
      }
      
      private function handleContentFileLoaded(param1:FZipEvent) : void
      {
         if(param1.file.filename.indexOf(".awp") != -1)
         {
            addDependency(param1.file.filename,new URLRequest(param1.file.filename),false,param1.file.content,false);
            pauseAndRetrieveDependencies();
         }
      }
   }
}

