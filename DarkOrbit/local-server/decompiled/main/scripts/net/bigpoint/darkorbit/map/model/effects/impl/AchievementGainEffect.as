package net.bigpoint.darkorbit.map.model.effects.impl
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class AchievementGainEffect extends MapObjectEffect
   {
      
      private static const _notificationsContainer:Sprite = new Sprite();
      
      private var _notification:AchievementNotification;
      
      public function AchievementGainEffect(param1:Ship, param2:String, param3:String = null, param4:String = null)
      {
         super(EffectIDList.ACHIEVEMENT_GAIN_EFFECT,param1,NOT_PERSISTANT,new EffectPattern(EffectIDList.ACHIEVEMENT_GAIN_EFFECT,"achievementGain"),InGameCatalog.SOUND_ID_NEW_ACHIEVEMENT);
         this._notification = new AchievementNotification(param2,param3,param4);
         this._excludeGroup = 1;
      }
      
      override public function activate() : Boolean
      {
         if(_notificationsContainer.parent == null)
         {
            ScreenManager.getInstance().topmenuLayer.addChild(_notificationsContainer);
         }
         this._notification.show(_notificationsContainer.getBounds(_notificationsContainer).bottom);
         _notificationsContainer.addChild(this._notification);
         return super.activate();
      }
   }
}

import com.greensock.TweenLite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.utils.setTimeout;
import net.bigpoint.as3toolbox.bplocale.BPLocale;
import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
import net.bigpoint.darkorbit.Styles;
import net.bigpoint.darkorbit.managers.ResourceManager;
import net.bigpoint.darkorbit.mvc.application.GameFacade;
import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
import net.bigpoint.darkorbit.net.JavascriptProxy;
import tools.Scale9Grid;

class AchievementNotification extends Sprite
{
   
   private static const ACHIEVEMENT_GLOWFILTER:GlowFilter = new GlowFilter(13809664,1,6,6,2,1,true);
   
   private var _key:String;
   
   private var _count:String;
   
   private var _time:String;
   
   private var _clip:MovieClip;
   
   public function AchievementNotification(param1:String, param2:String, param3:String)
   {
      super();
      this._key = param1;
      this._count = param2;
      this._time = param3;
      addEventListener(MouseEvent.ROLL_OVER,this.handleAchievementRollOver);
      addEventListener(MouseEvent.ROLL_OUT,this.handleAchievementRollOut);
      addEventListener(MouseEvent.CLICK,this.handleAchievementClick);
   }
   
   public function show(param1:Number) : void
   {
      this.y = param1;
      GameFacade.getInstance().forwardNotification(AssetNotifications.LOAD_ASSET,[this._key + "_30x30",this.handleExpansionResourceLoaded,null,AssetsProxy.ACHIEVEMENTS]);
   }
   
   private function handleExpansionResourceLoaded(param1:ImageFinisher) : void
   {
      var _loc2_:ImageFinisher = null;
      var _loc8_:TextField = null;
      _loc2_ = param1;
      var _loc3_:BitmapData = ResourceManager.getBitmapData("ui","achievementBG");
      var _loc4_:String = _loc2_.fileVO.id;
      var _loc5_:RegExp = /_30x30/;
      var _loc6_:String = _loc4_.replace(_loc5_,"");
      var _loc7_:String = BPLocale.getItemInCategory("achievements",_loc6_ + "_name");
      _loc8_ = new TextField();
      _loc8_.selectable = false;
      _loc8_.autoSize = TextFieldAutoSize.LEFT;
      _loc8_.defaultTextFormat = Styles.achievementUITitleFmt;
      _loc8_.antiAliasType = AntiAliasType.ADVANCED;
      _loc8_.embedFonts = Styles.achievementUIEmbed;
      _loc8_.text = _loc7_;
      _loc8_.x = 42;
      _loc8_.y = 9;
      var _loc9_:TextField = new TextField();
      _loc9_.selectable = false;
      var _loc10_:String = BPLocale.getItemInCategory("achievements",_loc6_ + "_description");
      _loc9_.autoSize = TextFieldAutoSize.LEFT;
      var _loc11_:RegExp = /%COUNT%/;
      _loc9_.defaultTextFormat = Styles.achievementUIDescriptionFmt;
      _loc9_.embedFonts = Styles.achievementUIEmbed;
      _loc9_.antiAliasType = AntiAliasType.ADVANCED;
      var _loc12_:String = _loc10_.replace(_loc11_,this._count || "");
      _loc9_.text = _loc12_.replace("%TIME%",this._time || "");
      _loc9_.x = 42;
      _loc9_.y = 24;
      var _loc13_:String = _loc9_.text.replace("<i>","");
      var _loc14_:String = _loc13_.replace("</i>","");
      _loc9_.text = _loc14_;
      var _loc15_:Bitmap = _loc2_.getBitmap();
      this._clip = new MovieClip();
      var _loc16_:Number = _loc8_.width >= _loc9_.width ? _loc8_.width : _loc9_.width;
      if(_loc16_ > 240)
      {
         _loc16_ += 50;
      }
      else
      {
         _loc16_ = 280;
      }
      var _loc17_:Scale9Grid = new Scale9Grid(new Rectangle(9,0,1,45),_loc16_,45,_loc3_);
      this._clip.addChild(_loc17_);
      this._clip.addChild(_loc15_);
      this._clip.addChild(_loc8_);
      this._clip.addChild(_loc9_);
      _loc15_.x = 7;
      _loc15_.y = 9;
      this._clip.x = 5;
      this._clip.y = -50;
      this._clip.alpha = 0;
      addChild(this._clip);
      this._clip.mouseChildren = false;
      this._clip.buttonMode = true;
      TweenLite.to(this._clip,0.8,{
         "y":0,
         "alpha":1
      });
      setTimeout(this.removeAchievementWindow,6000);
   }
   
   private function handleAchievementClick(param1:MouseEvent) : void
   {
      JavascriptProxy.referToURL("internalPilotSheet","seo_title_achievements","achievements",true);
   }
   
   private function handleAchievementRollOut(param1:MouseEvent) : void
   {
      this.filters = [];
   }
   
   private function handleAchievementRollOver(param1:MouseEvent) : void
   {
      this.filters = [ACHIEVEMENT_GLOWFILTER];
   }
   
   private function removeAchievementWindow() : void
   {
      TweenLite.to(this._clip,0.8,{
         "y":-50,
         "alpha":0,
         "onComplete":this.removeAsset
      });
   }
   
   private function removeAsset() : void
   {
      TweenLite.killTweensOf(this._clip);
      if(parent)
      {
         parent.removeChild(this);
      }
   }
}
