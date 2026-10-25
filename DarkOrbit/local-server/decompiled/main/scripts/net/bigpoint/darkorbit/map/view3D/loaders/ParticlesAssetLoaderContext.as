package net.bigpoint.darkorbit.map.view3D.loaders
{
   import away3d.loaders.misc.AssetLoaderContext;
   import away3d.loaders.misc.SingleFileLoader;
   
   public class ParticlesAssetLoaderContext extends AssetLoaderContext
   {
      
      private var _resourcesLifetime:uint;
      
      public function ParticlesAssetLoaderContext(param1:uint, param2:String = null)
      {
         super(true,param2);
         this._resourcesLifetime = param1;
      }
      
      override public function hasMappingForUrl(param1:String) : Boolean
      {
         return true;
      }
      
      override public function getRemappedUrl(param1:String) : String
      {
         if(param1.indexOf(".awp") == -1 && param1.indexOf(".zip") == -1)
         {
            param1 = this.joinUrl(dependencyBaseUrl,param1);
            param1 = param1.replace(".obj",".awd");
            param1 = param1.replace(".png",".atf");
         }
         return param1;
      }
      
      private function joinUrl(param1:String, param2:String) : String
      {
         if(param2.charAt(0) == "/")
         {
            param2 = param2.substr(1);
         }
         if(param1.length == 0)
         {
            return param2;
         }
         if(param1.charAt(param1.length - 1) == "/")
         {
            param1 = param1.substr(0,param1.length - 1);
         }
         return param1.concat("/",param2);
      }
      
      override public function createFileLoader(param1:uint) : SingleFileLoader
      {
         return new DOParticleFileLoader(this._resourcesLifetime,param1);
      }
   }
}

