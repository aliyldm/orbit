package net.bigpoint.darkorbit.map.view3D.display3D.render
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.data.RenderableListItem;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.render.RendererBase;
   import away3d.core.traverse.EntityCollector;
   import away3d.materials.MaterialBase;
   import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DCompareMode;
   import flash.display3D.textures.TextureBase;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.map.view3D.debug.Stats3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.background.DOSkybox;
   
   use namespace arcane;
   
   public class DORenderer extends RendererBase
   {
      
      private static var RTT_PASSES:int = 1;
      
      private static var SCREEN_PASSES:int = 2;
      
      private static var ALL_PASSES:int = 3;
      
      public var renderSkybox:Boolean = false;
      
      private var _skybox:DOSkybox = new DOSkybox();
      
      private var _activeMaterial:MaterialBase;
      
      public function DORenderer(param1:Boolean = false)
      {
         super(param1);
      }
      
      override arcane function set stage3DProxy(param1:Stage3DProxy) : void
      {
         super.arcane::stage3DProxy = param1;
      }
      
      override arcane function createEntityCollector() : EntityCollector
      {
         return new DOEntityCollector();
      }
      
      override protected function executeRender(param1:EntityCollector, param2:TextureBase = null, param3:Rectangle = null, param4:int = 0) : void
      {
         if(param2)
         {
            if(this.renderSkybox)
            {
               this._skybox.render(_stage3DProxy,param1,_rttViewProjectionMatrix);
            }
            Stats3D.renderablesOpaque = this.drawRenderables(param1.opaqueRenderableHead,param1,RTT_PASSES);
            Stats3D.renderablesTransparent = this.drawRenderables(param1.blendedRenderableHead,param1,RTT_PASSES);
         }
         super.executeRender(param1,param2,param3,param4);
      }
      
      override protected function draw(param1:EntityCollector, param2:TextureBase) : void
      {
         if(this.renderSkybox)
         {
            this._skybox.render(_stage3DProxy,param1,_rttViewProjectionMatrix);
         }
         _context.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
         _context.setDepthTest(true,Context3DCompareMode.LESS_EQUAL);
         var _loc3_:int = param2 ? SCREEN_PASSES : ALL_PASSES;
         Stats3D.renderablesOpaque = this.drawRenderables(param1.opaqueRenderableHead,param1,_loc3_);
         Stats3D.renderablesTransparent = this.drawRenderables(param1.blendedRenderableHead,param1,_loc3_);
         if(this._activeMaterial)
         {
            this._activeMaterial.deactivate(_stage3DProxy);
         }
         this._activeMaterial = null;
         _context.setDepthTest(false,Context3DCompareMode.LESS_EQUAL);
      }
      
      private function drawRenderables(param1:RenderableListItem, param2:EntityCollector, param3:int) : int
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc8_:RenderableListItem = null;
         var _loc9_:int = 0;
         var _loc4_:int = 0;
         var _loc7_:Camera3D = param2.camera;
         while(param1)
         {
            this._activeMaterial = param1.renderable.material;
            this._activeMaterial.updateMaterial(_context);
            _loc5_ = this._activeMaterial.numPasses;
            _loc6_ = 0;
            do
            {
               _loc8_ = param1;
               _loc9_ = this._activeMaterial.passRendersToTexture(_loc6_) ? 1 : 2;
               if((_loc9_ & param3) != 0)
               {
                  this._activeMaterial.activatePass(_loc6_,_stage3DProxy,_loc7_);
                  do
                  {
                     _loc4_++;
                     this._activeMaterial.renderPass(_loc6_,_loc8_.renderable,_stage3DProxy,param2,_rttViewProjectionMatrix);
                  }
                  while(_loc8_ = _loc8_.next, (Boolean(_loc8_)) && _loc8_.renderable.material == this._activeMaterial);
                  this._activeMaterial.deactivatePass(_loc6_,_stage3DProxy);
               }
               else
               {
                  while(true)
                  {
                     _loc8_ = _loc8_.next;
                     if(!((Boolean(_loc8_)) && _loc8_.renderable.material == this._activeMaterial))
                     {
                        break;
                     }
                  }
               }
            }
            while(++_loc6_ < _loc5_);
            param1 = _loc8_;
         }
         return _loc4_;
      }
      
      override arcane function dispose() : void
      {
         super.arcane::dispose();
      }
      
      public function get skybox() : DOSkybox
      {
         return this._skybox;
      }
   }
}

