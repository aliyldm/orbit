package net.bigpoint.darkorbit.mvc.application.view
{
   import com.greensock.layout.AlignMode;
   import com.greensock.layout.AutoFitArea;
   import com.greensock.layout.ScaleMode;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class ClientSelectionView extends Sprite
   {
      
      public static var Selected3D:String = "3D";
      
      public static var Selected2D:String = "2D";
      
      public static var SelectedFAQ:String = "FAQ";
      
      private var _autoFitarea:AutoFitArea;
      
      private var _bg:Bitmap;
      
      private var _center:Center = new Center();
      
      public function ClientSelectionView()
      {
         super();
         this._bg = ResourceManager.getBitmap("clientSelection","bg");
         addChild(this._bg);
         var _loc1_:DisplayObject = ResourceManager.getBitmap("clientSelection","bot_left");
         var _loc2_:DisplayObject = ResourceManager.getBitmap("clientSelection","bot_right");
         var _loc3_:DisplayObject = ResourceManager.getBitmap("clientSelection","up_left");
         var _loc4_:DisplayObject = ResourceManager.getBitmap("clientSelection","up_right");
         if(Settings.has3DCapabilities)
         {
            this._center.button3d.addEventListener(MouseEvent.CLICK,this.clicked3d);
            this._center.button2d.addEventListener(MouseEvent.CLICK,this.clicked2d);
         }
         else
         {
            this._center.button3d.addEventListener(MouseEvent.CLICK,this.clicked2d);
            this._center.button2d.addEventListener(MouseEvent.CLICK,this.clickedFRQ);
         }
         this._autoFitarea = new AutoFitArea(this);
         this._autoFitarea.attach(addChild(_loc1_),ScaleMode.NONE,AlignMode.LEFT,AlignMode.BOTTOM);
         this._autoFitarea.attach(addChild(_loc2_),ScaleMode.NONE,AlignMode.RIGHT,AlignMode.BOTTOM);
         this._autoFitarea.attach(addChild(_loc3_),ScaleMode.NONE,AlignMode.LEFT,AlignMode.TOP);
         this._autoFitarea.attach(addChild(_loc4_),ScaleMode.NONE,AlignMode.RIGHT,AlignMode.TOP);
         this._autoFitarea.attach(addChild(this._center),ScaleMode.NONE,AlignMode.CENTER,AlignMode.CENTER);
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
      }
      
      private function addedToStage(param1:Event) : void
      {
         this.updateSize();
         stage.addEventListener(Event.RESIZE,this.updateSize);
      }
      
      private function clicked3d(param1:MouseEvent) : void
      {
         if(Settings.has3DCapabilities)
         {
            dispatchEvent(new Event(Selected3D));
         }
         else
         {
            dispatchEvent(new Event(Selected2D));
         }
         dispatchEvent(new Event(Selected3D));
         MovieClipUtils.removeDisplayObject(this);
      }
      
      private function clicked2d(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(Selected2D));
         MovieClipUtils.removeDisplayObject(this);
      }
      
      private function clickedFRQ(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(SelectedFAQ));
      }
      
      private function updateSize(param1:* = null) : void
      {
         setTimeout(this.resize,1);
      }
      
      private function resize() : void
      {
         if(stage)
         {
            this._bg.width = stage.stageWidth;
            this._bg.height = stage.stageHeight;
            this._autoFitarea.height = stage.stageHeight;
            this._autoFitarea.width = stage.stageWidth;
            this._autoFitarea.update();
         }
      }
   }
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import net.bigpoint.as3toolbox.bplocale.BPLocale;
import net.bigpoint.darkorbit.Styles;
import net.bigpoint.darkorbit.fui.components.custom.ResultLabel;
import net.bigpoint.darkorbit.managers.ResourceManager;
import net.bigpoint.darkorbit.settings.Settings;
import net.bigpoint.darkorbit.utils.BitmapUtils;

class SelectionButton extends Sprite
{
   
   private static const STATE_NORMAL:Rectangle = new Rectangle(0,0,278,90);
   
   private static const STATE_HOVER:Rectangle = new Rectangle(0,90,278,90);
   
   private static const STATE_DOWN:Rectangle = new Rectangle(0,180,278,90);
   
   private var _text:TextField;
   
   private var _img:Bitmap;
   
   public function SelectionButton(param1:String = "")
   {
      super();
      this._img = ResourceManager.getBitmap("clientSelection","button");
      addChild(this._img);
      this._img.scrollRect = STATE_NORMAL;
      this._text = new TextField();
      this._text.width = width;
      this._text.height = height;
      this._text.autoSize = TextFieldAutoSize.CENTER;
      this._text.defaultTextFormat = Styles.clientSelectionButton;
      this._text.embedFonts = Styles.baseEmbed;
      this._text.text = param1;
      this._text.mouseEnabled = false;
      this._text.y = 20;
      addChild(this._text);
      addEventListener(MouseEvent.MOUSE_OVER,this.over);
      addEventListener(MouseEvent.MOUSE_OUT,this.out);
      addEventListener(MouseEvent.MOUSE_DOWN,this.down);
   }
   
   private function down(param1:MouseEvent) : void
   {
      this._img.scrollRect = STATE_DOWN;
   }
   
   private function out(param1:MouseEvent) : void
   {
      this._img.scrollRect = STATE_NORMAL;
   }
   
   private function over(param1:MouseEvent) : void
   {
      this._img.scrollRect = STATE_HOVER;
   }
}

class Center extends Sprite
{
   
   private const FILTERS:Array;
   
   private var _2dViewButton:TextField;
   
   private var _3dViewButton:SelectionButton;
   
   public function Center()
   {
      var headline:ResultLabel;
      var bitmapData:BitmapData;
      var infoText:TextField;
      var errorIcon:Bitmap = null;
      this.FILTERS = [new GlowFilter(15436324,0.9,15,15,1,3)];
      super();
      addChild(ResourceManager.getBitmap("clientSelection","center"));
      headline = new ResultLabel();
      headline.width = 1600;
      headline.height = 100;
      headline.y = 600;
      bitmapData = ResourceManager.getBitmapData("clientSelection","gradient");
      bitmapData = BitmapUtils.scaleBitmapData(bitmapData,1,100 / bitmapData.height);
      headline.gradient = bitmapData;
      headline.textFormat = Styles.clientSelectionHeadline;
      headline.embededFonts = true;
      headline.filters = this.FILTERS;
      headline.text = BPLocale.getItem("client_selection_headline").toUpperCase();
      headline.x = width * 0.5 - headline.width * 0.5;
      if(Settings.has3DCapabilities == false)
      {
         errorIcon = ResourceManager.getBitmap("clientSelection","error_icon");
         errorIcon.x = width / 2 - errorIcon.width * 0.5;
         errorIcon.y = headline.y + 70;
         addChild(errorIcon);
      }
      infoText = new TextField();
      infoText.embedFonts = Styles.baseEmbed;
      infoText.defaultTextFormat = Styles.clientSelection;
      infoText.autoSize = TextFieldAutoSize.CENTER;
      infoText.wordWrap = true;
      infoText.multiline = true;
      infoText.y = Settings.has3DCapabilities ? headline.y + 116 : errorIcon.y + errorIcon.height;
      infoText.width = this.width - 500;
      infoText.htmlText = Settings.has3DCapabilities ? BPLocale.getItem("client_selection_info") : BPLocale.getItem("client_selection_info_no_3d");
      infoText.x = width * 0.5 - infoText.width * 0.5;
      addChild(infoText);
      this._3dViewButton = new SelectionButton(Settings.has3DCapabilities ? BPLocale.getItem("client_selection_3d") : BPLocale.getItem("client_selection_continue_2d"));
      this._3dViewButton.buttonMode = true;
      this._3dViewButton.x = width / 2 - this._3dViewButton.width / 2;
      this._3dViewButton.y = infoText.y + infoText.height + 20;
      addChild(this._3dViewButton);
      this._2dViewButton = new TextField();
      this._2dViewButton.embedFonts = Styles.baseEmbed;
      this._2dViewButton.selectable = false;
      this._2dViewButton.width = this._3dViewButton.width;
      this._2dViewButton.autoSize = TextFieldAutoSize.CENTER;
      this._2dViewButton.wordWrap = true;
      this._2dViewButton.multiline = true;
      this._2dViewButton.defaultTextFormat = Styles.clientSelectionButton2D;
      this._2dViewButton.htmlText = "<a href=\'event:null\'>" + (Settings.has3DCapabilities ? BPLocale.getItem("client_selection_2d") : BPLocale.getItem("client_selection_faq")) + "</a>";
      this._2dViewButton.y = this._3dViewButton.y + 85;
      this._2dViewButton.x = width / 2 - this._2dViewButton.width / 2;
      addChild(this._2dViewButton);
      addChild(headline);
      this._2dViewButton.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
      {
         _2dViewButton.textColor = 255;
      });
      this._2dViewButton.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void
      {
         _2dViewButton.textColor = uint(Styles.clientSelectionButton2D.color);
      });
   }
   
   public function get button2d() : TextField
   {
      return this._2dViewButton;
   }
   
   public function get button3d() : SelectionButton
   {
      return this._3dViewButton;
   }
}
