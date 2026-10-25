package net.bigpoint.darkorbit.mvc.gui.windows.mileageMarket.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.MileageMarketInfoCommand;
   import net.bigpoint.darkorbit.com.module.MileageMarketInfoUpdateCommand;
   import net.bigpoint.darkorbit.com.module.MileageMarketPackageModule;
   import net.bigpoint.darkorbit.com.module.MileageMarketPackageUpdateCommand;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class MileageMarketUIData extends EventDispatcher
   {
      
      public const infoUpdated:ISignal = new Signal();
      
      public const countdownTimer:BindableCountDown = new BindableCountDown();
      
      public const coins:BindableInt = new BindableInt(0,0);
      
      private var _packList:Vector.<String> = new Vector.<String>(0);
      
      private var _bundleList:Vector.<MileageMarketVO> = new Vector.<MileageMarketVO>(0);
      
      public function MileageMarketUIData()
      {
         super();
      }
      
      public function updateInfo(param1:MileageMarketInfoCommand) : void
      {
         this._packList = param1.packageList;
         this.countdownTimer.value = param1.timeToEventEnd;
         this.coins.value = param1.coinCount;
         this._packList = param1.packageList;
         this.setBundleList(param1.exchangePackages);
         this.infoUpdated.dispatch();
      }
      
      public function updatePackageBought(param1:MileageMarketInfoUpdateCommand) : void
      {
         this.coins.value = param1.coinCount;
      }
      
      public function updateBundleBought(param1:MileageMarketPackageUpdateCommand) : void
      {
         var _loc2_:MileageMarketVO = null;
         if(this.bundleList == null)
         {
            return;
         }
         for each(_loc2_ in this.bundleList)
         {
            if(_loc2_.bundleId.indexOf(param1.packageID) >= 0)
            {
               _loc2_.updateBundle(param1.claimedDiscountSteps,param1.isBought);
               break;
            }
         }
         this.bundleList.sort(MileageMarketVO.sort);
      }
      
      public function get packList() : Vector.<String>
      {
         return this._packList;
      }
      
      public function get bundleList() : Vector.<MileageMarketVO>
      {
         return this._bundleList;
      }
      
      private function setBundleList(param1:Vector.<MileageMarketPackageModule>) : void
      {
         var _loc2_:MileageMarketPackageModule = null;
         this._bundleList = new Vector.<MileageMarketVO>(0);
         for each(_loc2_ in param1)
         {
            this._bundleList.push(new MileageMarketVO(_loc2_,this.coins.value));
         }
         if(this._bundleList != null)
         {
            this._bundleList.sort(MileageMarketVO.sort);
         }
      }
   }
}

