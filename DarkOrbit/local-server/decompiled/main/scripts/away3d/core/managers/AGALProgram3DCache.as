package away3d.core.managers
{
   import away3d.arcane;
   import away3d.debug.Debug;
   import away3d.events.Stage3DEvent;
   import away3d.materials.passes.MaterialPassBase;
   import com.adobe.utils.AGALMiniAssembler;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Program3D;
   import flash.utils.ByteArray;
   
   use namespace arcane;
   
   public class AGALProgram3DCache
   {
      
      private static var _instances:Vector.<AGALProgram3DCache>;
      
      private static var _currentId:int;
      
      private var _stage3DProxy:Stage3DProxy;
      
      private var _program3Ds:Array;
      
      private var _ids:Array;
      
      private var _usages:Array;
      
      private var _keys:Array;
      
      public function AGALProgram3DCache(param1:Stage3DProxy, param2:AGALProgram3DCacheSingletonEnforcer)
      {
         super();
         if(!param2)
         {
            throw new Error("This class is a multiton and cannot be instantiated manually. Use Stage3DManager.getInstance instead.");
         }
         this._stage3DProxy = param1;
         this._program3Ds = [];
         this._ids = [];
         this._usages = [];
         this._keys = [];
      }
      
      public static function getInstance(param1:Stage3DProxy) : AGALProgram3DCache
      {
         var _loc2_:int = param1._stage3DIndex;
         _instances = _instances || new Vector.<AGALProgram3DCache>(8,true);
         if(!_instances[_loc2_])
         {
            _instances[_loc2_] = new AGALProgram3DCache(param1,new AGALProgram3DCacheSingletonEnforcer());
            param1.addEventListener(Stage3DEvent.CONTEXT3D_DISPOSED,onContext3DDisposed,false,0,true);
            param1.addEventListener(Stage3DEvent.CONTEXT3D_CREATED,onContext3DDisposed,false,0,true);
            param1.addEventListener(Stage3DEvent.CONTEXT3D_RECREATED,onContext3DDisposed,false,0,true);
         }
         return _instances[_loc2_];
      }
      
      public static function getInstanceFromIndex(param1:int) : AGALProgram3DCache
      {
         return _instances[param1];
      }
      
      private static function onContext3DDisposed(param1:Stage3DEvent) : void
      {
         var _loc2_:Stage3DProxy = Stage3DProxy(param1.target);
         var _loc3_:int = _loc2_._stage3DIndex;
         _instances[_loc3_].dispose();
         _instances[_loc3_] = null;
         _loc2_.removeEventListener(Stage3DEvent.CONTEXT3D_DISPOSED,onContext3DDisposed);
         _loc2_.removeEventListener(Stage3DEvent.CONTEXT3D_CREATED,onContext3DDisposed);
         _loc2_.removeEventListener(Stage3DEvent.CONTEXT3D_RECREATED,onContext3DDisposed);
      }
      
      public function dispose() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this._program3Ds)
         {
            this.destroyProgram(_loc1_);
         }
         this._keys = null;
         this._program3Ds = null;
         this._usages = null;
      }
      
      public function setProgram3D(param1:MaterialPassBase, param2:String, param3:String) : void
      {
         var _loc5_:Program3D = null;
         var _loc9_:ByteArray = null;
         var _loc10_:ByteArray = null;
         var _loc4_:int = this._stage3DProxy._stage3DIndex;
         var _loc6_:String = this.getKey(param2,param3);
         if(this._program3Ds[_loc6_] == null)
         {
            this._keys[_currentId] = _loc6_;
            this._usages[_currentId] = 0;
            this._ids[_loc6_] = _currentId;
            ++_currentId;
            _loc5_ = this._stage3DProxy._context3D.createProgram();
            _loc9_ = new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.VERTEX,param2);
            _loc10_ = new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.FRAGMENT,param3);
            _loc5_.upload(_loc9_,_loc10_);
            this._program3Ds[_loc6_] = _loc5_;
         }
         var _loc7_:int = param1._program3Dids[_loc4_];
         var _loc8_:int = int(this._ids[_loc6_]);
         if(_loc7_ != _loc8_)
         {
            if(_loc7_ >= 0)
            {
               this.freeProgram3D(_loc7_);
            }
            ++this._usages[_loc8_];
         }
         param1._program3Dids[_loc4_] = _loc8_;
         param1._program3Ds[_loc4_] = this._program3Ds[_loc6_];
      }
      
      public function freeProgram3D(param1:int) : void
      {
         --this._usages[param1];
         if(this._usages[param1] == 0)
         {
            this.destroyProgram(this._keys[param1]);
         }
      }
      
      private function destroyProgram(param1:String) : void
      {
         this._program3Ds[param1].dispose();
         this._program3Ds[param1] = null;
         delete this._program3Ds[param1];
         this._ids[param1] = -1;
      }
      
      private function getKey(param1:String, param2:String) : String
      {
         return param1 + "---" + param2;
      }
   }
}

class AGALProgram3DCacheSingletonEnforcer
{
   
   public function AGALProgram3DCacheSingletonEnforcer()
   {
      super();
   }
}
