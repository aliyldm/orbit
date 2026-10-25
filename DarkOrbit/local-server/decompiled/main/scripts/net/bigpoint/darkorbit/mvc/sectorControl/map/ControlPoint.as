package net.bigpoint.darkorbit.mvc.sectorControl.map
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindableVector;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.minimap.traits.MiniMapIconTrait;
   import net.bigpoint.darkorbit.map.model.traits.PulsingRingTrait;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class ControlPoint extends MapEntity
   {
      
      private static const MINIMAP_KEYS:Array = [];
      
      MINIMAP_KEYS[FactionModule.FACTION_MMO] = "lock_mmo";
      MINIMAP_KEYS[FactionModule.FACTION_EIC] = "lock_eic";
      MINIMAP_KEYS[FactionModule.FACTION_VRU] = "lock_vru";
      
      public const captureThreshold:BindableInt = new BindableInt(100);
      
      public const progressOwner:BindableInt = new BindableInt();
      
      public const captureProgress:BindableInt = new BindableInt();
      
      public const invaders:BindableVector = new BindableVector(Vector.<Object>(new Vector.<FactionModule>()));
      
      public const growing:BindableBoolean = new BindableBoolean();
      
      public const isCaptured:BindableBoolean = new BindableBoolean();
      
      public const enabled:BindableBoolean = new BindableBoolean();
      
      private var _timeTillUnlock:Number = 0;
      
      private var _minimapTrait:MiniMapIconTrait;
      
      private var _clickIconTrait:ClickIconTrait;
      
      private var _timer:Timer = new Timer(1000);
      
      private var _tpf:int;
      
      private var _locked:Boolean = false;
      
      public function ControlPoint(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"sectorControlBeacon",UberAssetsLib.LIB_DEFAULT,this.handleIconClicked);
         addTrait(new PulsingRingTrait(true));
         this._minimapTrait = new MiniMapIconTrait("");
         this._clickIconTrait = getFirstTrait(ClickIconTrait) as ClickIconTrait;
         this._clickIconTrait.textFormatId.value = ClickIconTrait.TEXTFORMAT_ID_TIMER;
         this._clickIconTrait.enabled.value = true;
         addTrait(this._minimapTrait);
         this.invaders.changed.add(this.filterInvaders);
         this.captureProgress.changed.add(this.updateCapturedState);
         this._timer.addEventListener(TimerEvent.TIMER,this.updateTimer);
         this._tpf = getTimer();
         this.updateTimer();
         this.updateCapturedState();
      }
      
      override public function deactivateEntity() : void
      {
         this._timer.stop();
         super.deactivateEntity();
      }
      
      public function get isStable() : Boolean
      {
         return this.captureProgress.value == this.captureThreshold.value || this.captureProgress.value == 0;
      }
      
      public function get capturePercentage() : Number
      {
         return this.captureProgress.value / this.captureThreshold.value;
      }
      
      public function isPingAllowed() : Boolean
      {
         switch(this.invaders.length)
         {
            case 0:
               return false;
            case 1:
               if((this.invaders.getElementAt(0) as FactionModule).faction == this.progressOwner.value && this.isCaptured.value)
               {
                  return false;
               }
         }
         return true;
      }
      
      private function updateCapturedState() : void
      {
         if(this.captureThreshold.value == this.captureProgress.value)
         {
            this.isCaptured.value = true;
         }
         else if(this.captureProgress.value == 0)
         {
            this.isCaptured.value = false;
         }
      }
      
      private function filterInvaders() : void
      {
         var _loc1_:Vector.<FactionModule> = Vector.<FactionModule>(this.invaders.value);
         _loc1_.sort(this.sortInvaders);
         var _loc2_:uint = _loc1_.length;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            while(_loc3_ + 1 < _loc1_.length && _loc1_[_loc3_].faction == _loc1_[_loc3_ + 1].faction)
            {
               _loc1_.splice(_loc3_,1);
            }
            _loc3_++;
         }
      }
      
      private function sortInvaders(param1:FactionModule, param2:FactionModule) : int
      {
         return param1.faction - param2.faction;
      }
      
      private function updateTimer(param1:TimerEvent = null) : void
      {
         this._timeTillUnlock = Math.max(0,this._timeTillUnlock - (getTimer() - this._tpf));
         this._tpf = getTimer();
         this.update();
      }
      
      private function update() : void
      {
         this._clickIconTrait.text.value = TimeFormatter.formatTime(this._timeTillUnlock * 0.001);
         this._locked = this._timeTillUnlock > 0;
         if(this._locked)
         {
            this._tpf = getTimer();
            this._timer.start();
            this._minimapTrait.resKey = MINIMAP_KEYS[this.progressOwner.value] || "";
            addTrait(this._clickIconTrait);
         }
         else
         {
            this._timer.stop();
            this._minimapTrait.resKey = "";
            removeTrait(this._clickIconTrait);
         }
      }
      
      private function handleIconClicked() : void
      {
      }
      
      public function set timeTillUnlock(param1:Number) : void
      {
         this._timeTillUnlock = param1;
         this.update();
      }
   }
}

