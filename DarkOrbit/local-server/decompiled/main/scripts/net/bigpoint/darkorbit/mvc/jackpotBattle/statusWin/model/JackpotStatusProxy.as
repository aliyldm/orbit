package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.model
{
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.JackpotBattleNotification;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class JackpotStatusProxy extends Proxy implements IFrameObserver
   {
      
      public static const NAME:String = "JackpotStatusProxy";
      
      private var _diff:Number = 0;
      
      private var _warnigMode:Boolean;
      
      public function JackpotStatusProxy()
      {
         super(NAME);
      }
      
      override public function onRemove() : void
      {
         ScreenManager.removeObserver(this);
         super.onRemove();
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         ScreenManager.addObserver(this);
         sendNotification(JackpotBattleNotification.SET_LABLES_VISIBILITY,true);
      }
      
      private function get timeVo() : JackpotTimeVo
      {
         return data as JackpotTimeVo;
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:Boolean = false;
         this._diff += param1;
         while(this._diff > 1000)
         {
            this._diff -= 1000;
            --this.timeVo.time;
            _loc2_ = true;
         }
         if(_loc2_)
         {
            if(this.timeVo.time >= 0)
            {
               sendNotification(JackpotBattleNotification.UPDATE_REMAINING_TIME,this.timeVo.time);
               this.checkTime();
            }
            else
            {
               sendNotification(JackpotBattleNotification.SET_LABLES_VISIBILITY,false);
               ScreenManager.removeObserver(this);
            }
         }
      }
      
      private function checkTime() : void
      {
         var _loc1_:Boolean = this.timeVo.timeOffset >= this.timeVo.time ? true : false;
         if(_loc1_ != this._warnigMode)
         {
            this._warnigMode = _loc1_;
            if(this._warnigMode)
            {
               sendNotification(JackpotBattleNotification.SHOW_WARNING);
            }
            else
            {
               sendNotification(JackpotBattleNotification.HIDE_WARNING);
            }
         }
      }
   }
}

