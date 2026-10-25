package away3d.loaders.misc
{
   import away3d.arcane;
   import away3d.library.assets.IAsset;
   import away3d.loaders.parsers.ParserBase;
   import flash.net.URLRequest;
   
   use namespace arcane;
   
   public class ResourceDependency
   {
      
      private var _id:String;
      
      private var _req:URLRequest;
      
      private var _assets:Vector.<IAsset>;
      
      private var _parentParser:ParserBase;
      
      private var _data:*;
      
      private var _retrieveAsRawData:Boolean;
      
      private var _suppressAssetEvents:Boolean;
      
      private var _dependencies:Vector.<ResourceDependency>;
      
      arcane var loader:SingleFileLoader;
      
      arcane var success:Boolean;
      
      public function ResourceDependency(param1:String, param2:URLRequest, param3:*, param4:ParserBase, param5:Boolean = false, param6:Boolean = false)
      {
         super();
         this._id = param1;
         this._req = param2;
         this._parentParser = param4;
         this._data = param3;
         this._retrieveAsRawData = param5;
         this._suppressAssetEvents = param6;
         this._assets = new Vector.<IAsset>();
         this._dependencies = new Vector.<ResourceDependency>();
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get assets() : Vector.<IAsset>
      {
         return this._assets;
      }
      
      public function get dependencies() : Vector.<ResourceDependency>
      {
         return this._dependencies;
      }
      
      public function get request() : URLRequest
      {
         return this._req;
      }
      
      public function get retrieveAsRawData() : Boolean
      {
         return this._retrieveAsRawData;
      }
      
      public function get suppresAssetEvents() : Boolean
      {
         return this._suppressAssetEvents;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      arcane function setData(param1:*) : void
      {
         this._data = param1;
      }
      
      public function get parentParser() : ParserBase
      {
         return this._parentParser;
      }
      
      public function resolve() : void
      {
         if(this._parentParser)
         {
            this._parentParser.resolveDependency(this);
         }
      }
      
      public function resolveFailure() : void
      {
         if(this._parentParser)
         {
            this._parentParser.resolveDependencyFailure(this);
         }
      }
      
      public function resolveName(param1:IAsset) : String
      {
         if(this._parentParser)
         {
            return this._parentParser.resolveDependencyName(this,param1);
         }
         return param1.name;
      }
   }
}

