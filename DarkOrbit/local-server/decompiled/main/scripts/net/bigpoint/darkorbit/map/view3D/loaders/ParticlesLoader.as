package net.bigpoint.darkorbit.map.view3D.loaders
{
   import away3d.entities.Mesh;
   import away3d.entities.ParticleGroup;
   import away3d.events.LoaderEvent;
   import away3d.library.AssetLibrary;
   import away3d.loaders.Loader3D;
   import away3d.loaders.parsers.ParticleGroupParser;
   import away3d.materials.TextureMaterial;
   import flash.net.URLRequest;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.ExplosionMaterial;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import org.osflash.signals.Promise;
   
   public class ParticlesLoader extends AbstractLoader
   {
      
      AssetLibrary.enableParser(ParticleGroupParser);
      AssetLibrary.enableParser(DDSParser);
      AssetLibrary.enableParser(ZIPParser);
      
      public function ParticlesLoader()
      {
         super();
      }
      
      override public function reset(param1:uint) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in _loaders)
         {
            if(_loaders[_loc2_].lifetime <= param1)
            {
               _loaders[_loc2_] = null;
               delete _loaders[_loc2_];
            }
         }
         super.reset(param1);
      }
      
      public function loadParticleByUrl(param1:String, param2:uint, param3:Boolean = true) : Promise
      {
         var _loc4_:Object = _loaders[param1];
         if(_loc4_ == null || Settings3D.cacheDisabled.value)
         {
            _loaders[param1] = _loc4_ = {
               "loader":new Loader3D(false),
               "promise":new Promise(ParticleGroup),
               "url":param1,
               "lifetime":param2
            };
            _loc4_.loader.load(new URLRequest(param1),param3 ? new ParticlesAssetLoaderContext(param2) : null);
            _loc4_.loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE,this.handleLoadComplete);
            _loc4_.loader.addEventListener(LoaderEvent.LOAD_ERROR,this.handleLoadError);
         }
         return _loc4_.promise;
      }
      
      private function handleLoadComplete(param1:LoaderEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:ParticleGroup = null;
         var _loc5_:int = 0;
         var _loc2_:Loader3D = param1.currentTarget as Loader3D;
         for each(_loc3_ in _loaders)
         {
            if(_loc3_.loader == _loc2_)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc2_.numChildren)
               {
                  _loc4_ = _loc2_.getChildAt(_loc5_) as ParticleGroup;
                  if(_loc4_)
                  {
                     break;
                  }
                  _loc5_++;
               }
               if(_loc4_)
               {
                  this.updateMaterials(_loc4_,_loc3_.url);
                  Promise(_loc3_.promise).dispatch(_loc4_);
               }
               return;
            }
         }
      }
      
      private function updateMaterials(param1:ParticleGroup, param2:String) : void
      {
         var _loc6_:Mesh = null;
         var _loc7_:TextureMaterial = null;
         var _loc3_:Array = param1.customParamters.lightPickerTargets as Array || [];
         var _loc4_:Boolean = _loc3_.length == 1 && _loc3_[0] == "*";
         var _loc5_:int = 0;
         while(_loc5_ < param1.particleMeshes.length)
         {
            _loc6_ = param1.particleMeshes[_loc5_];
            if(_loc6_.material is TextureMaterial)
            {
               _loc7_ = _loc6_.material as TextureMaterial;
               if(_loc7_.texture)
               {
                  _loc7_.blendMode = ParticleBlendPolicy3D.select(_loc6_.name,_loc7_.texture.format,_loc7_.blendMode);
               }
            }
            if(_loc6_.name.indexOf("shader_fireball") != -1 && _loc6_.material is TextureMaterial)
            {
               _loc6_.material = new ExplosionMaterial(TextureMaterial(_loc6_.material).texture);
            }
            if(_loc4_ || _loc3_.indexOf(_loc6_.name) != -1 || _loc6_.name.indexOf("light_") != -1)
            {
               _loc6_.material.lightPicker = World3D.instance.lights.particlesPicker;
            }
            _loc5_++;
         }
      }
      
      private function handleLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in _loaders)
         {
            if(_loc2_.loader == param1.target)
            {
               Promise(_loc2_.promise).dispatch(null);
               return;
            }
         }
      }
   }
}

