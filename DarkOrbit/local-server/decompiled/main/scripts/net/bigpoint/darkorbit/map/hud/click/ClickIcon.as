package net.bigpoint.darkorbit.map.hud.click
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindablePointLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.ILayerChild;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.hud.AbstractHUDElement;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   
   public class ClickIcon extends AbstractHUDElement implements ILayerChild, IUpdatable, IDisposable
   {
      
      private static const TWEEN_TIME:Number = 0.3;
      
      private static const TEXTFORMATS:Array = [];
      
      TEXTFORMATS[ClickIconTrait.TEXTFORMAT_ID_STANDART] = Styles.clickIconFormat;
      TEXTFORMATS[ClickIconTrait.TEXTFORMAT_ID_TIMER] = Styles.clickIconFormatLockTimer;
      
      private var _clickIconView:MovieClip = new MovieClip();
      
      private var _optionalTextField:TextField;
      
      private var _data:ClickIconTrait;
      
      private var _highlight:ClickIconHighlight;
      
      public function ClickIcon(param1:IMapView, param2:ClickIconTrait)
      {
         super(param1,new BindablePointLite());
         this._data = param2;
         this._data.enabled.changed.add(this.handleEnableChanged);
         this._data.highlight.changed.add(this.handleHighlightChanged);
         this._data.rolledOver.add(this.handleRollOverChanged);
         this._data.rolledOut.add(this.handleRollOutChanged);
         this._data.text.changed.add(this.handleTextChanged);
         this._data.textFormatId.changed.add(this.setTextFormat);
         ResourceManager.fileCollection.load(param2.iconResource.srcKey,this.handleIconResourceReady);
      }
      
      private function handleRollOutChanged() : void
      {
         if(this._clickIconView)
         {
            this._clickIconView.gotoAndStop(1);
         }
      }
      
      private function handleRollOverChanged() : void
      {
         if(this._clickIconView)
         {
            this._clickIconView.gotoAndStop(2);
         }
      }
      
      override public function updateObj(param1:Number) : void
      {
         var _loc2_:PointLite = null;
         _loc2_ = this._data.getScreenPosition(_mapView);
         x = _loc2_.x - this._data.clickScreenOffset.x;
         y = _loc2_.y - this._data.clickScreenOffset.y;
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this._highlight)
         {
            this._highlight.deactivate();
         }
         super.disposeView(param1);
      }
      
      private function handleIconResourceReady(param1:SWFFinisher) : void
      {
         this._clickIconView = param1.getEmbeddedObject(this._data.iconResource.resKey) as MovieClip;
         this._clickIconView.gotoAndStop(1);
         addChildAt(this._clickIconView,0);
         this.handleEnableChanged(false);
         this._highlight = new ClickIconHighlight(this._clickIconView);
         if(this._optionalTextField)
         {
            this.addTextfield();
         }
         this.handleHighlightChanged();
      }
      
      private function handleEnableChanged(param1:Boolean = true) : void
      {
         this._clickIconView.gotoAndStop(1);
         if(this._data.enabled.value)
         {
            TweenLite.to(this._clickIconView,param1 ? TWEEN_TIME : 0,{
               "alpha":1,
               "scaleX":1,
               "scaleY":1
            });
         }
         else
         {
            TweenLite.to(this._clickIconView,param1 ? TWEEN_TIME : 0,{
               "alpha":0.5,
               "scaleX":0.75,
               "scaleY":0.75
            });
         }
      }
      
      private function handleHighlightChanged() : void
      {
         if(this._highlight)
         {
            if(this._data.highlight.value)
            {
               this._highlight.activate();
            }
            else
            {
               this._highlight.deactivate();
            }
         }
      }
      
      private function handleTextChanged() : void
      {
         if(this._optionalTextField == null)
         {
            this.setupTextfield();
         }
         this._optionalTextField.text = this._data.text.value || "";
      }
      
      private function setupTextfield() : void
      {
         this._optionalTextField = this._optionalTextField ? this._optionalTextField : new TextField();
         this._optionalTextField.text = " ";
         this.setTextFormat();
         this._optionalTextField.embedFonts = Styles.baseEmbed;
         this._optionalTextField.autoSize = TextFieldAutoSize.CENTER;
         this._optionalTextField.y = this._optionalTextField.height - 70;
         this._optionalTextField.x = 0;
         this.addTextfield();
      }
      
      private function addTextfield() : void
      {
         var _loc1_:int = 0;
         if(this._clickIconView)
         {
            _loc1_ = this._clickIconView.currentFrame;
            this._clickIconView.gotoAndStop(1);
            this._clickIconView.addChild(this._optionalTextField);
            this._clickIconView.gotoAndStop(_loc1_);
         }
      }
      
      private function setTextFormat() : void
      {
         if(this._optionalTextField)
         {
            this._optionalTextField.defaultTextFormat = TEXTFORMATS[this._data.textFormatId.value] || TEXTFORMATS[ClickIconTrait.TEXTFORMAT_ID_STANDART];
         }
      }
      
      public function get layer() : int
      {
         return 4;
      }
   }
}

