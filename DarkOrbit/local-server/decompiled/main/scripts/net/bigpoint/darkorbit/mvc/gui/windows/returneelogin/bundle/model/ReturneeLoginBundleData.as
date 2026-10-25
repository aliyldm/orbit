package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.bundle.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.ReturneeLoginBundleInfoCommand;
   
   public class ReturneeLoginBundleData extends EventDispatcher
   {
      
      public static const PREFIX:String = "items_package_";
      
      public const countdownTimer:BindableCountDown = new BindableCountDown();
      
      private var _bundleList:Vector.<String> = new Vector.<String>(0);
      
      public function ReturneeLoginBundleData()
      {
         super();
      }
      
      public function get bundleList() : Vector.<String>
      {
         if(!this._bundleList || this._bundleList.length == 0)
         {
            this._bundleList = new Vector.<String>(0);
            this._bundleList.push("event-deal-returnee-s");
            this._bundleList.push("event-deal-returnee-m");
            this._bundleList.push("event-deal-returnee-l");
            this._bundleList.push("event-deal-returnee-xl");
         }
         return this._bundleList;
      }
      
      public function updateDay(param1:ReturneeLoginBundleInfoCommand) : void
      {
         this.countdownTimer.value = param1.timeToEndEvent;
      }
   }
}

