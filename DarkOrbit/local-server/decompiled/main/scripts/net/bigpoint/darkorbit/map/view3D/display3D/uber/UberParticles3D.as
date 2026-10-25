package net.bigpoint.darkorbit.map.view3D.display3D.uber
{
   import away3d.entities.ParticleGroup;
   import com.bigpoint.utils.bindables.BindableString;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   
   public class UberParticles3D extends UberContainer3D implements IDisposable
   {
      
      public var url:String;
      
      public var parentId:String;
      
      private var _url:String;
      
      private var _particles:Particle3D;
      
      public function UberParticles3D(param1:XML = null, param2:BindableString = null)
      {
         if(param1)
         {
            this._url = String(param1.@url);
         }
         super(param1,param2);
      }
      
      public function get particles() : ParticleGroup
      {
         return this._particles.view;
      }
      
      override protected function loadView() : void
      {
         this.unloadView();
         this._particles = new Particle3D(this._url,_descriptor == null || String(_descriptor.@usePool) != "false");
         this._particles.ready.addOnce(this.handleEffectLoadComplete);
         World3D.instance.mapView.addUpdatable(this._particles);
         World3D.instance.mapView.addRenderable(this._particles);
      }
      
      override protected function unloadView() : void
      {
         if(this._particles)
         {
            this._particles.ready.remove(this.handleEffectLoadComplete);
            this._particles.disposeView(true);
            World3D.instance.mapView.removeUpdatable(this._particles);
            World3D.instance.mapView.removeRenderable(this._particles);
            this._particles = null;
         }
      }
      
      public function loadParticles(param1:String) : void
      {
         this._url = param1;
         reload();
      }
      
      private function handleEffectLoadComplete() : void
      {
         if(this._particles.view)
         {
            addChild(this._particles.view);
            setTimeout(ready.dispatch,1);
         }
      }
   }
}

