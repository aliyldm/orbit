package net.bigpoint.darkorbit.map.view2D.backgrounds.view.uber
{
   import flash.display.BitmapData;
   import flash.utils.getDefinitionByName;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.traits.UberBackgroundDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.model.BackgroundElementVO;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.view.AbstractBackgroundElement2D;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.display.DisplayObjectsBuilder;
   import net.bigpoint.darkorbit.mvc.display.IDODisplayObject;
   import net.bigpoint.darkorbit.mvc.display.IDisplayObject;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.model.ViewCreateDTO;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.view.IAnimatedViewContainer;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class UberBackgroundElement2D extends AbstractBackgroundElement2D
   {
      
      private static const DECORATORS:Object = {};
      
      DECORATORS["trainingArenaScore"] = TrainingArenaScoreDecorator2D;
      
      private var _builder:DisplayObjectsBuilder;
      
      private var _collider:BitmapData;
      
      private var _colliderX:int = 0;
      
      private var _colliderY:int = 0;
      
      private var _colliderScaleX:Number = 1;
      
      private var _colliderScaleY:Number = 1;
      
      private var _decorators:Vector.<IUberBackgroundDecorator3D> = new Vector.<IUberBackgroundDecorator3D>();
      
      private var _trait:UberBackgroundDisplayTrait;
      
      private var _descriptor:IAnimatedViewContainer;
      
      public function UberBackgroundElement2D(param1:DisplayObjectsBuilder, param2:UberBackgroundDisplayTrait)
      {
         super(param1.buildSprite() as IDisplayObject,new BackgroundElementVO(param2.layer,param2.parallaxFactor));
         this._trait = param2;
         this._builder = param1;
      }
      
      public function get descriptor() : IAnimatedViewContainer
      {
         return this._descriptor;
      }
      
      override public function update(param1:int, param2:int, param3:int, param4:int) : void
      {
         view.x = (this._trait.owner.x - param1) / this._trait.parallaxFactor + param3;
         view.y = (this._trait.owner.y - param2) / this._trait.parallaxFactor + param4;
      }
      
      override protected function meetsQualitySettings() : Boolean
      {
         return true;
      }
      
      override protected function loadView() : void
      {
         var _loc1_:IUberBackgroundDecorator3D = null;
         super.loadView();
         while(this._decorators.length)
         {
            _loc1_ = this._decorators.pop();
            if(_loc1_ is IDisposable)
            {
               IDisposable(_loc1_).disposeView();
            }
         }
         Settings.qualityBackground.changed.add(this.updateDescriptorQualities);
         Settings.autoQualityReduction.changed.add(this.updateDescriptorQualities);
         GameFacade.getInstance().sendNotification(MapAssetNotification.LOAD_MAPASSET_VIEW,new ViewCreateDTO(this._trait.viewDescriptorResKey,this.initView,this._builder,Boolean(this._trait.descriptor) && this._trait.descriptor.background2D.length() > 0 ? this._trait.descriptor.background2D[0] : null,this._trait.debug));
      }
      
      override protected function unloadView() : void
      {
         var _loc1_:IUberBackgroundDecorator3D = null;
         while(this._decorators.length)
         {
            _loc1_ = this._decorators.pop();
            if(_loc1_ is IDisposable)
            {
               IDisposable(_loc1_).disposeView();
            }
         }
         if(this._collider)
         {
            this._collider.dispose();
            this._collider = null;
         }
         Settings.qualityBackground.changed.remove(this.updateDescriptorQualities);
         Settings.autoQualityReduction.changed.remove(this.updateDescriptorQualities);
         super.unloadView();
      }
      
      override public function testLensFlareCollision(param1:int, param2:int) : Boolean
      {
         var _loc3_:uint = 0;
         if(this._collider)
         {
            _loc3_ = this._collider.getPixel32((param1 - view.x) * this._colliderScaleX - this._colliderX,(param2 - view.y) * this._colliderScaleY - this._colliderY);
            return _loc3_ >>> 24 > 128;
         }
         return false;
      }
      
      protected function initView(param1:IAnimatedViewContainer) : void
      {
         var _loc2_:String = null;
         var _loc3_:IUberBackgroundDecorator3D = null;
         this._descriptor = param1;
         view.addUntypedChild(this._descriptor.view);
         this.updateDescriptorQualities();
         for each(_loc2_ in this._trait.decorators)
         {
            if(DECORATORS[_loc2_] != null)
            {
               _loc3_ = new DECORATORS[_loc2_]();
               this._decorators.push(_loc3_);
               _loc3_.decorateUberAsset(this,this._trait);
            }
         }
         this.initCollider();
      }
      
      private function updateDescriptorQualities() : void
      {
         if(this._descriptor)
         {
            this._descriptor.userQuality = Settings.qualityBackground.value;
            this._descriptor.reductionLevel = Settings.autoQualityReduction.value;
         }
      }
      
      private function initCollider() : void
      {
         var _loc1_:String = this._descriptor.dto.xmlData.collision.@resKey;
         if(ResourceManager.fileCollection.fileExists(_loc1_))
         {
            ResourceManager.fileCollection.load(_loc1_,this.handleColliderReady);
         }
         else if(ResourceManager.fileCollection.fileExists(_loc1_))
         {
            ResourceManager.fileCollection.load(_loc1_,this.handleColliderReady);
         }
      }
      
      private function handleColliderReady(param1:ImageFinisher) : void
      {
         var _loc2_:XML = this._descriptor.dto.xmlData.child("collision")[0];
         var _loc3_:String = _loc2_.attribute("refId");
         this._collider = param1.getBitmap().bitmapData.clone();
         var _loc4_:IDODisplayObject = this._descriptor.getViewById(_loc3_);
         if(!_loc4_ || !this._collider)
         {
            return;
         }
         this._colliderScaleX = this._collider.width / _loc4_.width;
         this._colliderScaleY = this._collider.height / _loc4_.height;
         this._colliderX = _loc4_.x;
         this._colliderY = _loc4_.y;
         param1.dispose();
      }
   }
}

