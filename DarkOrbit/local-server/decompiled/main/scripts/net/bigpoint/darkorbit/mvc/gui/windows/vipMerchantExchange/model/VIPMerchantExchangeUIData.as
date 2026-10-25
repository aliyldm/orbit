package net.bigpoint.darkorbit.mvc.gui.windows.vipMerchantExchange.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.VIPMerchantExchangeInfoCommand;
   import net.bigpoint.darkorbit.com.module.VIPMerchantExchangeModule;
   import net.bigpoint.darkorbit.com.module.VIPMerchantExchangePackageUpdateCommand;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class VIPMerchantExchangeUIData extends EventDispatcher
   {
      
      public const infoUpdated:ISignal = new Signal();
      
      public const countdownTimer:BindableCountDown = new BindableCountDown();
      
      public const eligible:BindableBoolean = new BindableBoolean();
      
      private var _packList:Vector.<String> = new Vector.<String>(0);
      
      private var _exchangeList:Vector.<VIPMerchantExchangeVO> = new Vector.<VIPMerchantExchangeVO>(0);
      
      public function VIPMerchantExchangeUIData()
      {
         super();
      }
      
      public function updateInfo(param1:VIPMerchantExchangeInfoCommand) : void
      {
         this.countdownTimer.value = param1.timeToEventEnd;
         this.eligible.value = param1.packagesBought > 0;
         this._packList = param1.packageList;
         this.setExchangeList(param1.exchangeList);
         this.infoUpdated.dispatch();
      }
      
      public function updatePackageBought(param1:VIPMerchantExchangePackageUpdateCommand) : void
      {
         var _loc2_:VIPMerchantExchangeVO = null;
         this.eligible.value = param1.packagesBought > 0;
         for each(_loc2_ in this._exchangeList)
         {
            _loc2_.eligible = this.eligible.value;
         }
         this.eligible.changed.dispatch();
      }
      
      public function get packList() : Vector.<String>
      {
         return this._packList;
      }
      
      public function get exchangeList() : Vector.<VIPMerchantExchangeVO>
      {
         return this._exchangeList;
      }
      
      private function setExchangeList(param1:Vector.<VIPMerchantExchangeModule>) : void
      {
         var _loc2_:VIPMerchantExchangeModule = null;
         this._exchangeList = new Vector.<VIPMerchantExchangeVO>(0);
         for each(_loc2_ in param1)
         {
            this._exchangeList.push(new VIPMerchantExchangeVO(_loc2_,this.eligible.value));
         }
         this._exchangeList.sort(VIPMerchantExchangeVO.sort);
      }
   }
}

