package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.passes.SegmentPass;
   import flash.display.BlendMode;
   import flash.display3D.Context3DProgramType;
   
   use namespace arcane;
   
   public class CompactLightningPass3D extends SegmentPass
   {
      
      private var pixels:Vector.<Number> = Vector.<Number>([1,1,0.000001,0]);
      
      public function CompactLightningPass3D()
      {
         super(1);
         setBlendMode(BlendMode.ADD);
      }
      
      override arcane function getVertexCode() : String
      {
         var _loc1_:String = super.arcane::getVertexCode();
         var _loc2_:String = "sub vt2, vt1, vt0";
         var _loc3_:int = _loc1_.indexOf(_loc2_);
         var _loc4_:int = _loc1_.indexOf(_loc2_,_loc3_ + _loc2_.length);
         return _loc1_.substring(0,_loc4_) + "m44 vt0, vt0, vc0\n" + "m44 vt1, vt1, vc0\n" + "div vt2.xy, vt0.xy, vt0.ww\n" + "div vt3.xy, vt1.xy, vt1.ww\n" + "sub vt2.xy, vt3.xy, vt2.xy\n" + "mul vt2.xy, vt2.xy, vc12.xy\n" + "mov vt2.z, vc12.w\n" + "dp3 vt4.x, vt2.xyz, vt2.xyz\n" + "max vt4.x, vt4.x, vc12.z\n" + "rsq vt4.x, vt4.x\n" + "mul vt2.xy, vt2.xy, vt4.xx\n" + "mov vt3.x, vt2.y\n" + "neg vt3.y, vt2.x\n" + "div vt3.xy, vt3.xy, vc12.xy\n" + "mul vt3.xy, vt3.xy, va2.xx\n" + "mul vt3.xy, vt3.xy, vt0.ww\n" + "add vt0.xy, vt0.xy, vt3.xy\n" + "mov op, vt0\n" + "mov v0, va3\n";
      }
      
      override arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
      {
         super.arcane::activate(param1,param2);
         this.pixels[0] = param1.scissorRect ? param1.scissorRect.width : param1.width;
         this.pixels[1] = param1.scissorRect ? param1.scissorRect.height : param1.height;
         param1.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,12,this.pixels);
      }
   }
}

