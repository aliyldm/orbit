package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.model
{
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.DispatchGateModule;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.model.vo.DispatchGateVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class DispatchGateData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      private var _gateVOs:Vector.<DispatchGateVO> = new Vector.<DispatchGateVO>(0);
      
      public function DispatchGateData()
      {
         super();
      }
      
      public function updateGateList(param1:Vector.<DispatchGateModule>) : void
      {
         this._gateVOs = new Vector.<DispatchGateVO>(0);
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this._gateVOs.push(new DispatchGateVO(param1[_loc2_]));
            _loc2_++;
         }
         this.changed.dispatch();
      }
      
      public function get gateData() : Vector.<DispatchGateVO>
      {
         return this._gateVOs;
      }
   }
}

