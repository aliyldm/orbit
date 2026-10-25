package away3d.animators
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.passes.MaterialPassBase;
   import flash.display3D.Context3D;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class VertexAnimationSet extends AnimationSetBase implements IAnimationSet
   {
      
      private var _streamIndices:Dictionary = new Dictionary(true);
      
      public function VertexAnimationSet()
      {
         super();
      }
      
      public function getAGALVertexCode(param1:MaterialPassBase, param2:Vector.<String>, param3:Vector.<String>, param4:String) : String
      {
         var _loc5_:String = "";
         var _loc6_:String = findTempReg(param3);
         var _loc7_:String = findTempReg(param3,_loc6_);
         var _loc8_:String = "vc" + param1.numUsedVertexConstants;
         var _loc9_:Boolean = Boolean(param2.length > 1);
         var _loc10_:Boolean = Boolean(param2.length > 2);
         var _loc11_:uint = uint(this._streamIndices[param1] = param1.numUsedStreams);
         _loc5_ += "mov " + _loc6_ + ", " + param2[0] + "\n";
         _loc5_ = _loc5_ + ("mul " + _loc6_ + ", va" + _loc11_++ + ", " + _loc8_ + ".x\n");
         _loc5_ = _loc5_ + ("mul " + _loc7_ + ", va" + _loc11_++ + ", " + _loc8_ + ".y\n");
         _loc5_ = _loc5_ + ("add " + param3[0] + ", " + _loc6_ + ", " + _loc7_ + "\n");
         if(_loc9_)
         {
            _loc5_ += "mov " + param3[1] + ", " + param2[1] + "\n";
         }
         if(_loc10_)
         {
            _loc5_ += "dp3 " + _loc6_ + ".x, " + param2[uint(2)] + ", " + param3[uint(1)] + "\n" + "mul " + _loc6_ + ", " + param3[uint(1)] + ", " + _loc6_ + ".x\t\t\t \n" + "sub " + param3[uint(2)] + ", " + param2[uint(2)] + ", " + _loc6_ + "\n";
         }
         return _loc5_;
      }
      
      public function activate(param1:Stage3DProxy, param2:MaterialPassBase) : void
      {
      }
      
      public function deactivate(param1:Stage3DProxy, param2:MaterialPassBase) : void
      {
         var _loc3_:int = int(this._streamIndices[param2]);
         var _loc4_:Context3D = param1._context3D;
         _loc4_.setVertexBufferAt(_loc3_,null);
         _loc4_.setVertexBufferAt(_loc3_ + 1,null);
      }
      
      public function getAGALFragmentCode(param1:MaterialPassBase, param2:String, param3:String) : String
      {
         return "";
      }
      
      public function getAGALUVCode(param1:MaterialPassBase, param2:String, param3:String) : String
      {
         return "mov " + param3 + "," + param2 + "\n";
      }
      
      public function doneAGALCode(param1:MaterialPassBase) : void
      {
      }
   }
}

