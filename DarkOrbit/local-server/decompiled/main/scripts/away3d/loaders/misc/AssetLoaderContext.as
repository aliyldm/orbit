package away3d.loaders.misc
{
   import away3d.arcane;
   
   use namespace arcane;
   
   public class AssetLoaderContext
   {
      
      public static const UNDEFINED:uint = 0;
      
      public static const SINGLEPASS_MATERIALS:uint = 1;
      
      public static const MULTIPASS_MATERIALS:uint = 2;
      
      private var _includeDependencies:Boolean;
      
      private var _dependencyBaseUrl:String;
      
      private var _embeddedDataByUrl:Object;
      
      private var _remappedUrls:Object;
      
      private var _materialMode:uint;
      
      private var _overrideAbsPath:Boolean;
      
      private var _overrideFullUrls:Boolean;
      
      public function AssetLoaderContext(param1:Boolean = true, param2:String = null)
      {
         super();
         this._includeDependencies = param1;
         this._dependencyBaseUrl = param2 || "";
         this._embeddedDataByUrl = {};
         this._remappedUrls = {};
         this._materialMode = UNDEFINED;
      }
      
      public function get includeDependencies() : Boolean
      {
         return this._includeDependencies;
      }
      
      public function set includeDependencies(param1:Boolean) : void
      {
         this._includeDependencies = param1;
      }
      
      public function get materialMode() : uint
      {
         return this._materialMode;
      }
      
      public function set materialMode(param1:uint) : void
      {
         this._materialMode = param1;
      }
      
      public function get dependencyBaseUrl() : String
      {
         return this._dependencyBaseUrl;
      }
      
      public function set dependencyBaseUrl(param1:String) : void
      {
         this._dependencyBaseUrl = param1;
      }
      
      public function get overrideAbsolutePaths() : Boolean
      {
         return this._overrideAbsPath;
      }
      
      public function set overrideAbsolutePaths(param1:Boolean) : void
      {
         this._overrideAbsPath = param1;
      }
      
      public function get overrideFullURLs() : Boolean
      {
         return this._overrideFullUrls;
      }
      
      public function set overrideFullURLs(param1:Boolean) : void
      {
         this._overrideFullUrls = param1;
      }
      
      public function mapUrl(param1:String, param2:String) : void
      {
         this._remappedUrls[param1] = param2;
      }
      
      public function mapUrlToData(param1:String, param2:*) : void
      {
         this._embeddedDataByUrl[param1] = param2;
      }
      
      arcane function hasDataForUrl(param1:String) : Boolean
      {
         return this._embeddedDataByUrl.hasOwnProperty(param1);
      }
      
      arcane function getDataForUrl(param1:String) : *
      {
         return this._embeddedDataByUrl[param1];
      }
      
      public function hasMappingForUrl(param1:String) : Boolean
      {
         return this._remappedUrls.hasOwnProperty(param1);
      }
      
      public function getRemappedUrl(param1:String) : String
      {
         return this._remappedUrls[param1];
      }
      
      public function createFileLoader(param1:uint) : SingleFileLoader
      {
         return new SingleFileLoader(param1);
      }
   }
}

