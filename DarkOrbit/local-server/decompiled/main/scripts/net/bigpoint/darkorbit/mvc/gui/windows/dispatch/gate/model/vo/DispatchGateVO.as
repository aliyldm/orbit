package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.model.vo
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import com.bigpoint.utils.bindables.BindableInt;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.DispatchGateModule;
   import net.bigpoint.darkorbit.com.module.LootModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model.DispatchGateDefinition;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class DispatchGateVO
   {
      
      public var onCollect:ISignal = new Signal();
      
      private var _gateData:DispatchGateModule;
      
      private var _gateDefinition:DispatchGateDefinition;
      
      private var _timeLeft:BindableCountDown;
      
      private var _status:BindableInt;
      
      public function DispatchGateVO(param1:DispatchGateModule = null)
      {
         super();
         this._gateData = param1;
         this._gateDefinition = DispatchGateDefinition.getGateDefinition(this._gateData.gateId);
         this._timeLeft = new BindableCountDown(param1.timeLeft);
         this._status = new BindableInt(param1.status);
         if(Boolean(param1) && param1.status != DispatchGateModule.STATUSTYPE_IN_PROGRESS)
         {
            this._timeLeft.stop();
         }
         this._timeLeft.complete.add(this.onCompleteTimer);
      }
      
      public function get iconId() : String
      {
         return this._gateDefinition.iconId;
      }
      
      public function get dispatchId() : String
      {
         return this._gateDefinition.dispatchId;
      }
      
      public function get dispatchName() : String
      {
         return this._gateDefinition.name;
      }
      
      public function get timeLeft() : Number
      {
         return this._timeLeft.value;
      }
      
      public function set timeLeft(param1:Number) : void
      {
         this._timeLeft.value = this._gateData.timeLeft = param1;
      }
      
      public function get gateId() : int
      {
         return this._gateData.gateId;
      }
      
      public function costsToString() : String
      {
         if(this._gateData == null)
         {
            return "";
         }
         var _loc1_:LootModule = this._gateDefinition.sendCost;
         var _loc2_:String = ItemDataProviderHelper.getItem(_loc1_.lootId).fullname;
         var _loc3_:String = TextFormatter.roundInteger(_loc1_.amount);
         return BPLocale.getItemInCategory("base","dispatch_generic-itemlabel").replace("%LOOTID%",_loc2_).replace("%AMOUNT%",_loc3_);
      }
      
      public function get status() : int
      {
         return this._gateData.status;
      }
      
      public function set status(param1:int) : void
      {
         this._status.value = this._gateData.status = param1;
         if(!this._gateData)
         {
         }
      }
      
      public function addTimeLeftListener(param1:Function) : void
      {
         this._timeLeft.changed.add(param1);
      }
      
      public function removeTimeLeftListener(param1:Function) : void
      {
         this._timeLeft.changed.remove(param1);
      }
      
      private function onCompleteTimer() : void
      {
         this.status = DispatchGateModule.STATUSTYPE_READY_TO_COLLECT;
      }
      
      public function addStatusChangedListener(param1:Function) : void
      {
         this._status.changed.add(param1);
      }
      
      public function removeStatusChangedListener(param1:Function) : void
      {
         this._status.changed.remove(param1);
      }
   }
}

