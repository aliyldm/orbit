package net.bigpoint.darkorbit.map.view2D.effects.impl.retiarus
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectPersistantEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.NativeEffectClipPool2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.StandaloneEffect2D;
   
   public class BuffEffect2D extends StandaloneEffect2D
   {
      
      public function BuffEffect2D(param1:MapView2D, param2:MapObjectPersistantEffect)
      {
         super(param1,param2,param2.pattern.resKey,param2.source.position);
         if(!disposed)
         {
            param2.source.position.changed.add(this.update);
         }
      }
      
      private function update() : void
      {
         var _loc1_:MapObjectPersistantEffect = _effect as MapObjectPersistantEffect;
         var _loc2_:BindablePointLite = _loc1_.source.position;
         this.x = _loc2_.x;
         this.y = _loc2_.y;
      }
      
      override protected function onResourceLoaded(param1:SWFFinisher) : void
      {
         var finisher:SWFFinisher = param1;
         if(disposed)
         {
            return;
         }
         if(!finisher)
         {
            this.disposeView();
            return;
         }
         _mc = NativeEffectClipPool2D.acquire(finisher,_resKey);
         if(!_mc)
         {
            this.disposeView();
            return;
         }
         _mc.scaleY = _mc.scaleX = _effect.pattern.scale;
         addChild(_mc);
         _mc.visible = true;
         _mc.gotoAndPlay(1);
         _mc.addFrameScript(_mc.totalFrames - 1,function():void
         {
            _mc.gotoAndPlay(1);
         });
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(disposed)
         {
            return;
         }
         MapObjectPersistantEffect(_effect).source.position.changed.remove(this.update);
         if(_mc)
         {
            _mc.stop();
         }
         super.disposeView(param1);
      }
   }
}

