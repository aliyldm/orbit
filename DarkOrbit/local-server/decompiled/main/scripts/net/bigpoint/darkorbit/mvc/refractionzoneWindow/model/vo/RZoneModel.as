package net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo
{
   import com.bigpoint.utils.bindables.BindableObject;
   import flash.utils.getDefinitionByName;
   import net.bigpoint.darkorbit.com.module.RzoneClosingMapStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneConfirmationStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneLeavingStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneOnRZoneStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneQueueingStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneStatusCommand;
   import net.bigpoint.darkorbit.com.module.RzoneStatusModule;
   
   public class RZoneModel
   {
      
      private var _stateClasses:Object = {};
      
      public const currentState:BindableObject = new BindableObject();
      
      public function RZoneModel()
      {
         super();
         this._stateClasses[RzoneQueueingStatusModule.instance.getLibcomModuleId()] = QueueingCrossServerState;
         this._stateClasses[RzoneConfirmationStatusModule.instance.getLibcomModuleId()] = ConfirmationCrossServerState;
         this._stateClasses[RzoneClosingMapStatusModule.instance.getLibcomModuleId()] = ClosingCrossServerState;
         this._stateClasses[RzoneOnRZoneStatusModule.instance.getLibcomModuleId()] = OnRZoneCrossServerState;
         this._stateClasses[RzoneLeavingStatusModule.instance.getLibcomModuleId()] = LeavingCrossServerState;
      }
      
      public function update(param1:RzoneStatusCommand) : void
      {
         var _loc2_:BaseCrossServerState = null;
         if(!this.currentStateModule || this.currentStateModule.getLibcomModuleId() != param1.statusType.getLibcomModuleId())
         {
            this.disposeCurrentState();
            _loc2_ = this.createState(param1.statusType);
            _loc2_.state = param1.statusType;
            this.currentState.value = _loc2_;
         }
         else
         {
            (this.currentState.value as BaseCrossServerState).state = param1.statusType;
         }
      }
      
      private function disposeCurrentState() : void
      {
         if(this.currentState.value)
         {
            (this.currentState.value as BaseCrossServerState).dispose();
         }
      }
      
      private function get currentStateModule() : RzoneStatusModule
      {
         return this.currentState.value ? (this.currentState.value as BaseCrossServerState).state : null;
      }
      
      private function createState(param1:RzoneStatusModule) : BaseCrossServerState
      {
         return this._stateClasses[param1.getLibcomModuleId()] ? new this._stateClasses[param1.getLibcomModuleId()]() : new BaseCrossServerState();
      }
   }
}

