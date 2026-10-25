package away3d.library.assets
{
   import away3d.events.AssetEvent;
   import flash.events.EventDispatcher;
   
   public class NamedAssetBase extends EventDispatcher
   {
      
      public static const DEFAULT_NAMESPACE:String = "default";
      
      private var _originalName:String;
      
      private var _namespace:String;
      
      private var _name:String;
      
      private var _id:String;
      
      private var _full_path:Array;
      
      public function NamedAssetBase(param1:String = null)
      {
         super();
         if(param1 == null)
         {
            param1 = "null";
         }
         this._name = param1;
         this._originalName = param1;
         this.updateFullPath();
      }
      
      public function get originalName() : String
      {
         return this._originalName;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function set id(param1:String) : void
      {
         this._id = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:String = null;
         _loc2_ = this._name;
         this._name = param1;
         if(this._name == null)
         {
            this._name = "null";
         }
         this.updateFullPath();
         if(hasEventListener(AssetEvent.ASSET_RENAME))
         {
            dispatchEvent(new AssetEvent(AssetEvent.ASSET_RENAME,IAsset(this),_loc2_));
         }
      }
      
      public function get assetNamespace() : String
      {
         return this._namespace;
      }
      
      public function get assetFullPath() : Array
      {
         return this._full_path;
      }
      
      public function assetPathEquals(param1:String, param2:String) : Boolean
      {
         return this._name == param1 && (!param2 || this._namespace == param2);
      }
      
      public function resetAssetPath(param1:String, param2:String = null, param3:Boolean = true) : void
      {
         this._name = param1 ? param1 : "null";
         this._namespace = param2 ? param2 : DEFAULT_NAMESPACE;
         if(param3)
         {
            this._originalName = this._name;
         }
         this.updateFullPath();
      }
      
      private function updateFullPath() : void
      {
         this._full_path = [this._namespace,this._name];
      }
   }
}

