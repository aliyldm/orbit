package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.info.view
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.info.model.StrikeAndExitInfoData;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.info.model.StrikeAndExitInfoProxy;
   
   public class StrikeAndExitInfoMediator extends SimpleWindowMediator
   {
      
      private var _view:StrikeAndExitInfoView;
      
      private var data:StrikeAndExitInfoData;
      
      private var main:DisplayObjectContainer;
      
      private var item6:DisplayObjectContainer;
      
      private var endTime:Label;
      
      public const _treasureKey:String = "SpotLightUser";
      
      public const _boxersKey:String = "Boxers";
      
      public const _itemAKey:String = "BoxersIcon";
      
      public var npcIcons:Dictionary = new Dictionary();
      
      public var stellarName:String = "";
      
      public function StrikeAndExitInfoMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         var _loc1_:StrikeAndExitInfoProxy = new StrikeAndExitInfoProxy(GuiConstants.STRIKE_AND_EXIT_INFO);
         facade.registerProxy(_loc1_);
         this.data = _loc1_.viewData;
         this.data.changed.add(this.onDataChanged);
      }
      
      private function onDataChanged() : void
      {
         var _loc1_:String = null;
         if(this._view)
         {
            this.main.visible = true;
            this._view.boxersLabel.text = BPLocale.getItem("strikeandexit_ingame_box_num").replace("%VALUE%",this.data.boxRemainingQuantity);
            this._view.NPC1Label.text = BPLocale.getItem("strikeandexit_ingame_npc_3_num").replace("%VALUE%",this.data.npcRemainingQuantity1);
            this._view.NPC2Label.text = BPLocale.getItem("strikeandexit_ingame_npc_1_num").replace("%VALUE%",this.data.npcRemainingQuantity2);
            this._view.NPC3Label.text = BPLocale.getItem("strikeandexit_ingame_npc_2_num").replace("%VALUE%",this.data.npcRemainingQuantity3);
            this._view.spawn.text = BPLocale.getItem("strikeandexit_ingame_spawn_time").replace("%TIME%",TimeFormatter.getSmartFormatedTime(this.data.nextSpawnSeconds));
            this._view.itemALabel.text = this.stellarName + " " + this.data.saeScore;
            if(this.data.bossAlive)
            {
               this._view.bossLabel.text = BPLocale.getItem("strikeandexit_ingame_boss_alive");
            }
            else
            {
               this._view.bossLabel.text = BPLocale.getItem("strikeandexit_ingame_boss_spawn").replace("%TIME%",TimeFormatter.getSmartFormatedTime(this.data.nextSpawnNpcSeconds));
            }
            if(!this.data.spotLightUserName || this.data.spotLightUserName == "")
            {
               this.item6.visible = false;
            }
            else
            {
               _loc1_ = "(" + int(this.data.spotLightUserX / 100) + "," + int(this.data.spotLightUserY / 100) + ")";
               this._view.treasureLabel.text = BPLocale.getItem("strikeandexit_ingame_bounty_user").replace("%VALUE%",this.data.spotLightUserName + _loc1_);
               this.item6.visible = true;
            }
            this.setNPCIcon(this._view.NPC1Icon,this.data.npcType1);
            this.setNPCIcon(this._view.NPC2Icon,this.data.npcType2);
            this.setNPCIcon(this._view.NPC3Icon,this.data.npcType3);
            this.setNPCIcon(this._view.bossIcon,this.data.bossType);
            this.endTime.text = BPLocale.getItem("strikeandexit_ingame_end_time").replace("%VALUE%",TimeFormatter.getSmartFormatedTime(this.data.remainingTime));
         }
      }
      
      private function setNPCIcon(param1:Coreponent, param2:int) : void
      {
         if(this.npcIcons[param2])
         {
            param1.removeChildren();
            param1.addChild(this.npcIcons[param2]);
         }
         else
         {
            this.npcIcons[param2] = IconVOLoader.getInstance().setNpcIcon(param1,param2);
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new StrikeAndExitInfoView(this.simpleWindow);
         this._view.boxersLabel.text = BPLocale.getItem("strikeandexit_ingame_box_num");
         this._view.NPC1Label.text = BPLocale.getItem("strikeandexit_ingame_npc_1_num");
         this._view.NPC2Label.text = BPLocale.getItem("strikeandexit_ingame_npc_2_num");
         this._view.NPC3Label.text = BPLocale.getItem("strikeandexit_ingame_npc_3_num");
         this._view.spawn.text = BPLocale.getItem("strikeandexit_ingame_spawn_time");
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem("resource_collectable_stellar-coin");
         this._view.itemALabel.text = _loc2_.fullname + " 100/10000";
         this.stellarName = _loc2_.fullname;
         IconVOLoader.getInstance().loadIcon(this._view.itemAIcon,_loc2_,"100x100");
         this._view.bossLabel.text = BPLocale.getItem("strikeandexit_ingame_boss_spawn");
         this._view.treasureLabel.text = BPLocale.getItem("strikeandexit_ingame_bounty_user");
         IconVOLoader.getInstance().loadIcon(this._view.treasureIcon,null,this._treasureKey,AssetsProxy.EVENTS);
         IconVOLoader.getInstance().loadIcon(this._view.boxersIcon,null,this._boxersKey,AssetsProxy.EVENTS);
         this.main = this._view.mainContainer;
         this.item6 = this._view.tItem6;
         this.main.visible = false;
         this.item6.visible = false;
         var _loc3_:Button = this._view.infoButton;
         _loc3_.visible = false;
         _loc3_.addEventListener(MouseEvent.CLICK,this.onInfoButtonClick);
         this.endTime = this._view.endTime;
      }
      
      private function onInfoButtonClick(param1:MouseEvent) : void
      {
         simpleWindow.minimize();
         this.clear(GuiConstants.STRIKE_AND_EXIT_INFO);
      }
   }
}

