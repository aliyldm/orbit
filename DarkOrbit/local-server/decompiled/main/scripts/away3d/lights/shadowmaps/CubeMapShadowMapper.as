package away3d.lights.shadowmaps
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.cameras.lenses.PerspectiveLens;
   import away3d.containers.Scene3D;
   import away3d.core.render.DepthRenderer;
   import away3d.lights.PointLight;
   import away3d.textures.RenderCubeTexture;
   import away3d.textures.TextureProxyBase;
   import flash.display3D.textures.TextureBase;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class CubeMapShadowMapper extends ShadowMapperBase
   {
      
      private var _depthCameras:Vector.<Camera3D>;
      
      private var _lenses:Vector.<PerspectiveLens>;
      
      private var _needsRender:Vector.<Boolean>;
      
      public function CubeMapShadowMapper()
      {
         super();
         _depthMapSize = 512;
         this._needsRender = new Vector.<Boolean>(6,true);
         this.initCameras();
      }
      
      private function initCameras() : void
      {
         this._depthCameras = new Vector.<Camera3D>();
         this._lenses = new Vector.<PerspectiveLens>();
         this.addCamera(0,90,0);
         this.addCamera(0,-90,0);
         this.addCamera(-90,0,0);
         this.addCamera(90,0,0);
         this.addCamera(0,0,0);
         this.addCamera(0,180,0);
      }
      
      private function addCamera(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Camera3D = new Camera3D();
         _loc4_.rotationX = param1;
         _loc4_.rotationY = param2;
         _loc4_.rotationZ = param3;
         _loc4_.lens.near = 0.01;
         PerspectiveLens(_loc4_.lens).fieldOfView = 90;
         this._lenses.push(PerspectiveLens(_loc4_.lens));
         _loc4_.lens.aspectRatio = 1;
         this._depthCameras.push(_loc4_);
      }
      
      override protected function createDepthTexture() : TextureProxyBase
      {
         return new RenderCubeTexture(_depthMapSize);
      }
      
      override protected function updateDepthProjection(param1:Camera3D) : void
      {
         var _loc2_:Number = PointLight(_light)._fallOff;
         var _loc3_:Vector3D = _light.scenePosition;
         var _loc4_:uint = 0;
         while(_loc4_ < 6)
         {
            this._lenses[_loc4_].far = _loc2_;
            this._depthCameras[_loc4_].position = _loc3_;
            this._needsRender[_loc4_] = true;
            _loc4_++;
         }
      }
      
      override protected function drawDepthMap(param1:TextureBase, param2:Scene3D, param3:DepthRenderer) : void
      {
         var _loc4_:uint = 0;
         while(_loc4_ < 6)
         {
            if(this._needsRender[_loc4_])
            {
               _casterCollector.camera = this._depthCameras[_loc4_];
               _casterCollector.clear();
               param2.traversePartitions(_casterCollector);
               param3.render(_casterCollector,param1,null,_loc4_);
               _casterCollector.cleanUp();
            }
            _loc4_++;
         }
      }
   }
}

