package away3d.library
{
   import away3d.arcane;
   import away3d.library.assets.IAsset;
   import away3d.library.naming.ConflictStrategyBase;
   import away3d.library.utils.AssetLibraryIterator;
   import away3d.loaders.misc.AssetLoaderContext;
   import away3d.loaders.misc.AssetLoaderToken;
   import away3d.loaders.misc.SingleFileLoader;
   import away3d.loaders.parsers.ParserBase;
   import flash.net.URLRequest;
   
   use namespace arcane;
   
   public class AssetLibrary
   {
      
      arcane static var _instances:Object = {};
      
      public function AssetLibrary(param1:AssetLibrarySingletonEnforcer)
      {
         super();
         param1 = param1;
      }
      
      public static function getBundle(param1:String = "default") : AssetLibraryBundle
      {
         return AssetLibraryBundle.getInstance(param1);
      }
      
      public static function enableParser(param1:Class) : void
      {
         SingleFileLoader.enableParser(param1);
      }
      
      public static function enableParsers(param1:Vector.<Class>) : void
      {
         SingleFileLoader.enableParsers(param1);
      }
      
      public static function get conflictStrategy() : ConflictStrategyBase
      {
         return getBundle().conflictStrategy;
      }
      
      public static function set conflictStrategy(param1:ConflictStrategyBase) : void
      {
         getBundle().conflictStrategy = param1;
      }
      
      public static function get conflictPrecedence() : String
      {
         return getBundle().conflictPrecedence;
      }
      
      public static function set conflictPrecedence(param1:String) : void
      {
         getBundle().conflictPrecedence = param1;
      }
      
      public static function createIterator(param1:String = null, param2:String = null, param3:Function = null) : AssetLibraryIterator
      {
         return getBundle().createIterator(param1,param2,param3);
      }
      
      public static function load(param1:URLRequest, param2:AssetLoaderContext = null, param3:String = null, param4:ParserBase = null) : AssetLoaderToken
      {
         return getBundle().load(param1,param2,param3,param4);
      }
      
      public static function loadData(param1:*, param2:AssetLoaderContext = null, param3:String = null, param4:ParserBase = null) : AssetLoaderToken
      {
         return getBundle().loadData(param1,param2,param3,param4);
      }
      
      public static function stopLoad() : void
      {
         getBundle().stopAllLoadingSessions();
      }
      
      public static function getAsset(param1:String, param2:String = null) : IAsset
      {
         return getBundle().getAsset(param1,param2);
      }
      
      public static function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         getBundle().addEventListener(param1,param2,param3,param4,param5);
      }
      
      public static function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         getBundle().removeEventListener(param1,param2,param3);
      }
      
      public static function hasEventListener(param1:String) : Boolean
      {
         return getBundle().hasEventListener(param1);
      }
      
      public static function willTrigger(param1:String) : Boolean
      {
         return getBundle().willTrigger(param1);
      }
      
      public static function addAsset(param1:IAsset) : void
      {
         getBundle().addAsset(param1);
      }
      
      public static function removeAsset(param1:IAsset, param2:Boolean = true) : void
      {
         getBundle().removeAsset(param1,param2);
      }
      
      public static function removeAssetByName(param1:String, param2:String = null, param3:Boolean = true) : IAsset
      {
         return getBundle().removeAssetByName(param1,param2,param3);
      }
      
      public static function removeAllAssets(param1:Boolean = true) : void
      {
         getBundle().removeAllAssets(param1);
      }
      
      public static function removeNamespaceAssets(param1:String = null, param2:Boolean = true) : void
      {
         getBundle().removeNamespaceAssets(param1,param2);
      }
   }
}

class AssetLibrarySingletonEnforcer
{
   
   public function AssetLibrarySingletonEnforcer()
   {
      super();
   }
}
