package net.bigpoint.darkorbit.map.view3D.display3D.materials
{
   import away3d.materials.TextureMaterial;
   import away3d.materials.lightpickers.LightPickerBase;
   import flash.display.BlendMode;
   
   public class GhostMaterial extends TextureMaterial
   {
      
      private var _ghost:GhostMethod;
      
      public function GhostMaterial()
      {
         super();
         addMethod(this._ghost = new GhostMethod());
         this.blendMode = BlendMode.LAYER;
         this.alphaBlending = true;
         this.alphaPremultiplied = false;
      }
      
      override public function set blendMode(param1:String) : void
      {
         super.blendMode = BlendMode.LAYER;
      }
      
      override public function set alphaBlending(param1:Boolean) : void
      {
         super.alphaBlending = true;
         _screenPass.preserveAlpha = false;
      }
      
      override public function set alphaPremultiplied(param1:Boolean) : void
      {
         super.alphaPremultiplied = false;
      }
      
      override public function set lightPicker(param1:LightPickerBase) : void
      {
         super.lightPicker = null;
      }
   }
}

import away3d.arcane;
import away3d.cameras.Camera3D;
import away3d.core.base.IRenderable;
import away3d.core.managers.Stage3DProxy;
import away3d.materials.compilation.ShaderRegisterCache;
import away3d.materials.compilation.ShaderRegisterElement;
import away3d.materials.methods.EffectMethodBase;
import away3d.materials.methods.MethodVO;

use namespace arcane;

class GhostMethod extends EffectMethodBase
{
   
   public const DEFAULT_STRENGTH:Number = 1.4;
   
   public const DEFAULT_POWER:Number = 1.4;
   
   public const DEFAULT_COLOR:uint = 8372714;
   
   public function GhostMethod()
   {
      super();
   }
   
   override arcane function initVO(param1:MethodVO) : void
   {
      super.arcane::initVO(param1);
      param1.needsView = true;
      param1.needsNormals = true;
   }
   
   override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
   {
   }
   
   override arcane function setRenderState(param1:MethodVO, param2:IRenderable, param3:Stage3DProxy, param4:Camera3D) : void
   {
      super.arcane::setRenderState(param1,param2,param3,param4);
      var _loc5_:uint = uint(param2.shaderParams ? uint(param2.shaderParams.color) || uint(this.DEFAULT_COLOR) : uint(this.DEFAULT_COLOR));
      var _loc6_:Number = Number(param2.shaderParams ? Number(param2.shaderParams.strength) || Number(this.DEFAULT_STRENGTH) : Number(this.DEFAULT_STRENGTH));
      var _loc7_:Number = Number(param2.shaderParams ? Number(param2.shaderParams.power) || Number(this.DEFAULT_POWER) : Number(this.DEFAULT_POWER));
      var _loc8_:int = param1.fragmentConstantsIndex;
      var _loc9_:Vector.<Number> = param1.fragmentData;
      _loc9_[_loc8_] = (_loc5_ >> 16 & 0xFF) / 255;
      _loc9_[_loc8_ + 1] = (_loc5_ >> 8 & 0xFF) / 255;
      _loc9_[_loc8_ + 2] = (_loc5_ & 0xFF) / 255;
      _loc9_[_loc8_ + 3] = 1;
      _loc9_[_loc8_ + 4] = _loc6_;
      _loc9_[_loc8_ + 5] = _loc7_;
      _loc9_[_loc8_ + 6] = 1;
      _loc9_[_loc8_ + 7] = 0;
   }
   
   override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
   {
      var _loc4_:ShaderRegisterElement = param2.getFreeFragmentConstant();
      var _loc5_:ShaderRegisterElement = param2.getFreeFragmentConstant();
      var _loc6_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
      var _loc7_:String = "";
      param1.fragmentConstantsIndex = _loc4_.index * 4;
      _loc7_ += "mov " + param3 + ", " + _loc5_ + ".wwww\n";
      _loc7_ = _loc7_ + ("dp3 " + _loc6_ + ".x, " + _sharedRegisters.viewDirFragment + ".xyz, " + _sharedRegisters.normalFragment + ".xyz\t\n" + "sat " + _loc6_ + ".x, " + _loc6_ + ".x\t\t\t\t\t\t\t\t\t\t\t\t\t\t\n" + "sub " + _loc6_ + ".x, " + _loc4_ + ".w, " + _loc6_ + ".x\t\t\t\t\t\t\t\t\n" + "pow " + _loc6_ + ".x, " + _loc6_ + ".x, " + _loc5_ + ".y\t\t\t\t\t\t\t\n" + "mul " + _loc6_ + ".x, " + _loc6_ + ".x, " + _loc5_ + ".x\t\t\t\t\t\t\t\n" + "sub " + _loc6_ + ".x, " + _loc4_ + ".w, " + _loc6_ + ".x\t\t\t\t\t\t\t\t\n" + "mul " + param3 + ".xyz, " + param3 + ".xyz, " + _loc6_ + ".x\t\t\t\t\t\t\n" + "sub " + _loc6_ + ".w, " + _loc4_ + ".w, " + _loc6_ + ".x\t\t\t\t\t\t\t\t\n");
      return _loc7_ + ("sub " + _loc6_ + ".xyz, " + _loc4_ + ".xyz, " + param3 + ".xyz\t\t\t\t\n" + "mul " + _loc6_ + ".xyz, " + _loc6_ + ".xyz, " + _loc6_ + ".w\t\t\t\t\t\t\t\t\n" + "mov " + param3 + ", " + _loc6_ + "\t\t\t\t\t\n");
   }
}
