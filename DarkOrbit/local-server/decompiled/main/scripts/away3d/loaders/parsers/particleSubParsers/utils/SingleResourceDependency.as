package away3d.loaders.parsers.particleSubParsers.utils
{
   import away3d.arcane;
   import away3d.library.assets.IAsset;
   import away3d.loaders.misc.ResourceDependency;
   import away3d.loaders.parsers.CompositeParserBase;
   import flash.net.URLRequest;
   
   use namespace arcane;
   
   public class SingleResourceDependency extends ResourceDependency
   {
      
      private var _resolved:Boolean;
      
      private var _hasLoaded:Boolean;
      
      private var _originalUrl:String;
      
      public function SingleResourceDependency(param1:String, param2:URLRequest, param3:*, param4:CompositeParserBase, param5:Boolean = false, param6:Boolean = false)
      {
         var _loc8_:IAsset = null;
         this._originalUrl = param2.url;
         var _loc7_:Vector.<IAsset> = param4.root.getAssets(param2.url);
         if(_loc7_)
         {
            this._hasLoaded = true;
            param5 = true;
            param3 = true;
         }
         super(param1,param2,param3,param4,param5,param6);
         if(this._hasLoaded)
         {
            for each(_loc8_ in _loc7_)
            {
               assets.push(_loc8_);
            }
         }
      }
      
      override public function resolve() : void
      {
         if(!this._resolved)
         {
            if(!this._hasLoaded)
            {
               CompositeParserBase(parentParser).root.addAssets(this._originalUrl,assets);
            }
            this._resolved = true;
            super.resolve();
         }
      }
   }
}

