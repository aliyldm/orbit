package away3d.core.managers
{
   import away3d.arcane;
   import flash.display.Stage;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class Stage3DManager
   {
      
      private static var _instances:Dictionary;
      
      private static var _stageProxies:Vector.<Stage3DProxy>;
      
      private static var _numStageProxies:uint = 0;
      
      private var _stage:Stage;
      
      public function Stage3DManager(param1:Stage, param2:Stage3DManagerSingletonEnforcer)
      {
         super();
         if(!param2)
         {
            throw new Error("This class is a multiton and cannot be instantiated manually. Use Stage3DManager.getInstance instead.");
         }
         this._stage = param1;
         if(!_stageProxies)
         {
            _stageProxies = new Vector.<Stage3DProxy>(this._stage.stage3Ds.length,true);
         }
      }
      
      public static function getInstance(param1:Stage) : Stage3DManager
      {
         return (_instances = _instances || new Dictionary())[param1] = (_instances = _instances || new Dictionary())[param1] || new Stage3DManager(param1,new Stage3DManagerSingletonEnforcer());
      }
      
      public function getStage3DProxy(param1:uint, param2:Boolean = false, param3:String = "baseline") : Stage3DProxy
      {
         if(!_stageProxies[param1])
         {
            ++_numStageProxies;
            _stageProxies[param1] = new Stage3DProxy(param1,this._stage.stage3Ds[param1],this,param2,param3);
         }
         return _stageProxies[param1];
      }
      
      arcane function removeStage3DProxy(param1:Stage3DProxy) : void
      {
         --_numStageProxies;
         _stageProxies[param1.stage3DIndex] = null;
      }
      
      public function getFreeStage3DProxy(param1:Boolean = false, param2:String = "baseline") : Stage3DProxy
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = _stageProxies.length;
         while(_loc3_ < _loc4_)
         {
            if(!_stageProxies[_loc3_])
            {
               this.getStage3DProxy(_loc3_,param1,param2);
               _stageProxies[_loc3_].width = this._stage.stageWidth;
               _stageProxies[_loc3_].height = this._stage.stageHeight;
               return _stageProxies[_loc3_];
            }
            _loc3_++;
         }
         throw new Error("Too many Stage3D instances used!");
      }
      
      public function get hasFreeStage3DProxy() : Boolean
      {
         return _numStageProxies < _stageProxies.length ? true : false;
      }
      
      public function get numProxySlotsFree() : uint
      {
         return _stageProxies.length - _numStageProxies;
      }
      
      public function get numProxySlotsUsed() : uint
      {
         return _numStageProxies;
      }
      
      public function get numProxySlotsTotal() : uint
      {
         return _stageProxies.length;
      }
   }
}

class Stage3DManagerSingletonEnforcer
{
   
   public function Stage3DManagerSingletonEnforcer()
   {
      super();
   }
}
