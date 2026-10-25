package net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.RankingsEventsInfoRequest;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.model.vo.RankingsUIEventsVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class RankingsUIEventsData extends EventDispatcher
   {
      
      private static const UPDATE_INTERVAL_SECONDS:int = 1800;
      
      public const changed:ISignal = new Signal();
      
      public const rankType:BindableInt = new BindableInt(0,-1,RankingsEventsInfoRequest.RANKTYPE__MAX);
      
      public const countdown:BindableCountDown = new BindableCountDown();
      
      public const eventRunning:BindableBoolean = new BindableBoolean();
      
      private var _rankings:RankingsUIEventsVO;
      
      public function RankingsUIEventsData()
      {
         super();
         this.setCountdown();
      }
      
      public function setCountdown() : void
      {
         var _loc1_:Date = new Date();
         var _loc2_:Number = _loc1_.getMinutes() * 60;
         var _loc3_:int = _loc2_ % UPDATE_INTERVAL_SECONDS;
         this.countdown.value = _loc3_ == 0 ? UPDATE_INTERVAL_SECONDS : UPDATE_INTERVAL_SECONDS - _loc3_;
      }
      
      public function updateEventsInfo(param1:Boolean, param2:RankingsUIEventsVO) : void
      {
         this.eventRunning.value = param1;
         this._rankings = param1 ? param2 : null;
         this.changed.dispatch();
      }
      
      public function get rankings() : RankingsUIEventsVO
      {
         return this._rankings;
      }
   }
}

