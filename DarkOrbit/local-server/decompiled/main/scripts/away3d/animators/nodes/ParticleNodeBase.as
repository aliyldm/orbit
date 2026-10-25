package away3d.animators.nodes
{
   import away3d.animators.ParticleAnimationSet;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.ParticleProperties;
   import away3d.arcane;
   import away3d.materials.passes.MaterialPassBase;
   import flash.utils.getQualifiedClassName;
   
   use namespace arcane;
   
   public class ParticleNodeBase extends AnimationNodeBase
   {
      
      private static var GLOBAL:String = "Global";
      
      private static var LOCAL_STATIC:String = "LocalStatic";
      
      private static var LOCAL_DYNAMIC:String = "LocalDynamic";
      
      private static var MODES:Object = {
         0:GLOBAL,
         1:LOCAL_STATIC,
         2:LOCAL_DYNAMIC
      };
      
      protected var _mode:uint;
      
      private var _priority:int;
      
      protected var _dataLength:uint = 3;
      
      protected var _oneData:Vector.<Number>;
      
      arcane var dataOffset:uint;
      
      public function ParticleNodeBase(param1:String, param2:uint, param3:uint, param4:int = 1)
      {
         super();
         param1 += MODES[param2];
         this.name = param1;
         this._mode = param2;
         this._priority = param4;
         this._dataLength = param3;
         this._oneData = new Vector.<Number>(this._dataLength,true);
      }
      
      public static function getParticleNodeName(param1:Object, param2:uint) : String
      {
         var _loc3_:String = param1["ANIMATION_NODE_NAME"];
         if(!_loc3_)
         {
            _loc3_ = getNodeNameFromClass(param1);
         }
         return _loc3_ + MODES[param2];
      }
      
      private static function getNodeNameFromClass(param1:Object) : String
      {
         return getQualifiedClassName(param1).replace("Node","").split("::")[1];
      }
      
      public function get mode() : uint
      {
         return this._mode;
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function get dataLength() : int
      {
         return this._dataLength;
      }
      
      public function get oneData() : Vector.<Number>
      {
         return this._oneData;
      }
      
      public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         param1 = param1;
         param2 = param2;
         return "";
      }
      
      public function getAGALFragmentCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         param1 = param1;
         param2 = param2;
         return "";
      }
      
      public function getAGALUVCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         param1 = param1;
         param2 = param2;
         return "";
      }
      
      arcane function generatePropertyOfOneParticle(param1:ParticleProperties) : void
      {
      }
      
      arcane function processAnimationSetting(param1:ParticleAnimationSet) : void
      {
      }
   }
}

