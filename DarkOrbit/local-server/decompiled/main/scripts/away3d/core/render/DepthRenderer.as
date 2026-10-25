package away3d.core.render
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.data.RenderableListItem;
   import away3d.core.math.Plane3D;
   import away3d.core.traverse.EntityCollector;
   import away3d.entities.Entity;
   import away3d.materials.MaterialBase;
   import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DCompareMode;
   import flash.display3D.textures.TextureBase;
   import flash.geom.Rectangle;
   
   use namespace arcane;
   
   public class DepthRenderer extends RendererBase
   {
      
      private var _activeMaterial:MaterialBase;
      
      private var _renderBlended:Boolean;
      
      private var _distanceBased:Boolean;
      
      private var _disableColor:Boolean;
      
      public function DepthRenderer(param1:Boolean = false, param2:Boolean = false)
      {
         super();
         this._renderBlended = param1;
         this._distanceBased = param2;
         _backgroundR = 1;
         _backgroundG = 1;
         _backgroundB = 1;
      }
      
      public function get disableColor() : Boolean
      {
         return this._disableColor;
      }
      
      public function set disableColor(param1:Boolean) : void
      {
         this._disableColor = param1;
      }
      
      override arcane function set backgroundR(param1:Number) : void
      {
      }
      
      override arcane function set backgroundG(param1:Number) : void
      {
      }
      
      override arcane function set backgroundB(param1:Number) : void
      {
      }
      
      arcane function renderCascades(param1:EntityCollector, param2:TextureBase, param3:uint, param4:Vector.<Rectangle>, param5:Vector.<Camera3D>) : void
      {
         _renderTarget = param2;
         _renderTargetSurface = 0;
         _renderableSorter.sort(param1);
         _stage3DProxy.setRenderTarget(param2,true,0);
         _context.clear(1,1,1,1,1,0);
         _context.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
         _context.setDepthTest(true,Context3DCompareMode.LESS);
         var _loc6_:RenderableListItem = param1.opaqueRenderableHead;
         var _loc7_:Boolean = true;
         var _loc8_:* = int(param3 - 1);
         while(_loc8_ >= 0)
         {
            _stage3DProxy.scissorRect = param4[_loc8_];
            this.drawCascadeRenderables(_loc6_,param5[_loc8_],_loc7_ ? null : param5[_loc8_].frustumPlanes);
            _loc7_ = false;
            _loc8_--;
         }
         if(this._activeMaterial)
         {
            this._activeMaterial.deactivateForDepth(_stage3DProxy);
         }
         this._activeMaterial = null;
         _context.setDepthTest(false,Context3DCompareMode.LESS_EQUAL);
         _stage3DProxy.scissorRect = null;
      }
      
      private function drawCascadeRenderables(param1:RenderableListItem, param2:Camera3D, param3:Vector.<Plane3D>) : void
      {
         var _loc4_:MaterialBase = null;
         var _loc5_:IRenderable = null;
         var _loc6_:Entity = null;
         while(param1)
         {
            if(param1.cascaded)
            {
               param1 = param1.next;
            }
            else
            {
               _loc5_ = param1.renderable;
               _loc6_ = _loc5_.sourceEntity;
               if(!param3 || _loc6_.worldBounds.isInFrustum(param3,4))
               {
                  _loc4_ = _loc5_.material;
                  if(this._activeMaterial != _loc4_)
                  {
                     if(this._activeMaterial)
                     {
                        this._activeMaterial.deactivateForDepth(_stage3DProxy);
                     }
                     this._activeMaterial = _loc4_;
                     this._activeMaterial.activateForDepth(_stage3DProxy,param2,false);
                  }
                  this._activeMaterial.renderDepth(_loc5_,_stage3DProxy,param2,param2.viewProjection);
               }
               else
               {
                  param1.cascaded = true;
               }
               param1 = param1.next;
            }
         }
      }
      
      override protected function draw(param1:EntityCollector, param2:TextureBase) : void
      {
         _context.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
         _context.setDepthTest(true,Context3DCompareMode.LESS);
         this.drawRenderables(param1.opaqueRenderableHead,param1);
         if(this._disableColor)
         {
            _context.setColorMask(false,false,false,false);
         }
         if(this._renderBlended)
         {
            this.drawRenderables(param1.blendedRenderableHead,param1);
         }
         if(this._activeMaterial)
         {
            this._activeMaterial.deactivateForDepth(_stage3DProxy);
         }
         if(this._disableColor)
         {
            _context.setColorMask(true,true,true,true);
         }
         this._activeMaterial = null;
      }
      
      private function drawRenderables(param1:RenderableListItem, param2:EntityCollector) : void
      {
         var _loc4_:RenderableListItem = null;
         var _loc3_:Camera3D = param2.camera;
         while(param1)
         {
            this._activeMaterial = param1.renderable.material;
            if(this._disableColor && this._activeMaterial.hasDepthAlphaThreshold())
            {
               _loc4_ = param1;
               while(true)
               {
                  _loc4_ = _loc4_.next;
                  if(!((Boolean(_loc4_)) && _loc4_.renderable.material == this._activeMaterial))
                  {
                     break;
                  }
               }
            }
            else
            {
               this._activeMaterial.activateForDepth(_stage3DProxy,_loc3_,this._distanceBased);
               _loc4_ = param1;
               do
               {
                  this._activeMaterial.renderDepth(_loc4_.renderable,_stage3DProxy,_loc3_,_rttViewProjectionMatrix);
               }
               while(_loc4_ = _loc4_.next, (Boolean(_loc4_)) && _loc4_.renderable.material == this._activeMaterial);
               this._activeMaterial.deactivateForDepth(_stage3DProxy);
            }
            param1 = _loc4_;
         }
      }
   }
}

