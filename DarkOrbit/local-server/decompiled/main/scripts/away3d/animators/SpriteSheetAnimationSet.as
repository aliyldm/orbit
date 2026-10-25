package away3d.animators
{
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.passes.MaterialPassBase;
   import flash.display3D.Context3D;
   
   public class SpriteSheetAnimationSet extends AnimationSetBase implements IAnimationSet
   {
      
      private var _agalCode:String;
      
      public function SpriteSheetAnimationSet()
      {
         super();
      }
      
      public function getAGALVertexCode(param1:MaterialPassBase, param2:Vector.<String>, param3:Vector.<String>, param4:String) : String
      {
         var _loc5_:uint = param3.length;
         this._agalCode = "";
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            this._agalCode += "mov " + param3[_loc6_] + ", " + param2[_loc6_] + "\n";
            _loc6_++;
         }
         return this._agalCode;
      }
      
      public function activate(param1:Stage3DProxy, param2:MaterialPassBase) : void
      {
      }
      
      public function deactivate(param1:Stage3DProxy, param2:MaterialPassBase) : void
      {
         var _loc3_:Context3D = param1.context3D;
         _loc3_.setVertexBufferAt(0,null);
      }
      
      public function getAGALFragmentCode(param1:MaterialPassBase, param2:String, param3:String) : String
      {
         return "";
      }
      
      public function getAGALUVCode(param1:MaterialPassBase, param2:String, param3:String) : String
      {
         var _loc4_:String = "vt" + param2.substring(2,3);
         var _loc5_:int = int(param1.numUsedVertexConstants);
         var _loc6_:String = "vc" + _loc5_;
         this._agalCode = "mov " + _loc4_ + ", " + param2 + "\n";
         this._agalCode += "mul " + _loc4_ + ".xy, " + _loc4_ + ".xy, " + _loc6_ + ".zw \n";
         this._agalCode += "add " + _loc4_ + ".xy, " + _loc4_ + ".xy, " + _loc6_ + ".xy \n";
         this._agalCode += "mov " + param3 + ", " + _loc4_ + "\n";
         return this._agalCode;
      }
      
      public function doneAGALCode(param1:MaterialPassBase) : void
      {
      }
   }
}

