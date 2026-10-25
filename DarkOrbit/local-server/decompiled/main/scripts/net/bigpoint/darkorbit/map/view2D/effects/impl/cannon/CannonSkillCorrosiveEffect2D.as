package net.bigpoint.darkorbit.map.view2D.effects.impl.cannon
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonSkillCorrosiveEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.CompactEffectGeometry2D;
   import net.bigpoint.darkorbit.map.view2D.effects.NativeEffectClipPool2D;
   import net.bigpoint.darkorbit.map.view2D.effects.TimedEffectClip2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.StandaloneEffect2D;
   
   public class CannonSkillCorrosiveEffect2D extends StandaloneEffect2D
   {
      
      public function CannonSkillCorrosiveEffect2D(param1:MapView2D, param2:CannonSkillCorrosiveEffect)
      {
         super(param1,param2,"cannon_skill_corrosive",param2.source.position);
         if(!disposed)
         {
            param2.source.position.changed.add(this.update);
         }
      }
      
      private function update() : void
      {
         var _loc1_:CannonSkillCorrosiveEffect = _effect as CannonSkillCorrosiveEffect;
         var _loc2_:BindablePointLite = _loc1_.source.position;
         this.x = _loc2_.x;
         this.y = _loc2_.y;
      }
      
      override protected function onResourceLoaded(param1:SWFFinisher) : void
      {
         if(disposed)
         {
            return;
         }
         if(!param1)
         {
            this.disposeView();
            return;
         }
         _mc = NativeEffectClipPool2D.acquire(param1,_resKey);
         if(!_mc)
         {
            this.disposeView();
            return;
         }
         addChild(_mc);
         _mc.visible = true;
         CompactEffectGeometry2D.burst(_mc);
         TimedEffectClip2D.play(_mc,this,true);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(disposed)
         {
            return;
         }
         CannonSkillCorrosiveEffect(_effect).source.position.changed.remove(this.update);
         super.disposeView(param1);
      }
   }
}

