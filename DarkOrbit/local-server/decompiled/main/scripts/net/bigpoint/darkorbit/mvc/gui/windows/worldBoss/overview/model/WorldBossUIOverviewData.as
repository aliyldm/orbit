package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.overview.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindableNumber;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.WorldBossInfoUpdateCommand;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossInfoCommand;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class WorldBossUIOverviewData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      public const bossHealth:BindableNumber = new BindableNumber(0,0);
      
      public const currTier:BindableInt = new BindableInt(1,1);
      
      public const endTime:BindableCountDown = new BindableCountDown();
      
      public const attemptsLeft:BindableCountDown = new BindableCountDown();
      
      public var inRaiding:Boolean = false;
      
      private var _bossName:String = "worldboss_overview_total_damage";
      
      private var _bannerKey:String = "ingame-news_World-Boss-June-2025";
      
      private var _sloganKey:String = "worldboss_overview_banner_bastion";
      
      private var _descriptionKey:String = "worldboss_overview_info2025";
      
      public function WorldBossUIOverviewData()
      {
         super();
      }
      
      public function get bossName() : String
      {
         return this._bossName;
      }
      
      public function get bannerKey() : String
      {
         return this._bannerKey;
      }
      
      public function get sloganKey() : String
      {
         return this._sloganKey;
      }
      
      public function get descriptionKey() : String
      {
         return this._descriptionKey;
      }
      
      public function updateInfo(param1:PublicWorldBossInfoCommand) : void
      {
         this.bossHealth.maxValue = param1.maxHealth;
         this.bossHealth.value = param1.currHealth;
         this.currTier.value = param1.currTier;
         this.endTime.value = param1.timeToEventEndSeconds;
         this.attemptsLeft.value = param1.timeToNextRaidSeconds;
         this.inRaiding = param1.raiding;
         this.changed.dispatch();
      }
      
      public function updateBossInfo(param1:WorldBossInfoUpdateCommand) : void
      {
         this.bossHealth.maxValue = param1.maxHealth;
         this.bossHealth.value = param1.currHealth;
         this.currTier.value = param1.currTier;
      }
   }
}

