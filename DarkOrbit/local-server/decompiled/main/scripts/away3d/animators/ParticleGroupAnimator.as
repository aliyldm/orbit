package away3d.animators
{
   import away3d.animators.data.ParticleGroupEventProperty;
   import away3d.animators.data.ParticleInstanceProperty;
   import away3d.entities.Mesh;
   import away3d.events.ParticleGroupEvent;
   
   public class ParticleGroupAnimator extends AnimatorBase
   {
      
      private var animators:Vector.<ParticleAnimator> = new Vector.<ParticleAnimator>();
      
      private var animatorTimeOffset:Vector.<int>;
      
      private var numAnimator:int;
      
      private var eventList:Vector.<ParticleGroupEventProperty>;
      
      public function ParticleGroupAnimator(param1:Vector.<Mesh>, param2:Vector.<ParticleInstanceProperty>, param3:Vector.<ParticleGroupEventProperty>)
      {
         var _loc4_:int = 0;
         var _loc5_:Mesh = null;
         var _loc6_:ParticleAnimator = null;
         super(null);
         this.numAnimator = param1.length;
         this.animatorTimeOffset = new Vector.<int>(param1.length,true);
         while(_loc4_ < this.numAnimator)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = _loc5_.animator as ParticleAnimator;
            this.animators.push(_loc6_);
            _loc6_.autoUpdate = false;
            if(param2[_loc4_])
            {
               this.animatorTimeOffset[_loc4_] = param2[_loc4_].timeOffset * 1000;
            }
            _loc4_++;
         }
         this.eventList = param3;
      }
      
      override public function dispose() : void
      {
         stop();
         this.numAnimator = 0;
         while(this.animators.length)
         {
            this.animators.pop().dispose();
         }
         this.animatorTimeOffset = null;
         this.eventList = null;
      }
      
      override public function start() : void
      {
         super.start();
         this.resetPlayback();
      }
      
      public function startAt(param1:int) : void
      {
         super.startWithTime(param1);
         this.resetPlayback();
      }
      
      private function resetPlayback() : void
      {
         var _loc1_:int = 0;
         var _loc2_:ParticleAnimator = null;
         this.time = 0;
         while(_loc1_ < this.numAnimator)
         {
            _loc2_ = this.animators[_loc1_];
            _loc2_.time = -_loc2_.time / _loc2_.playbackSpeed + _loc2_.time;
            _loc2_.resetTime(time + this.animatorTimeOffset[_loc1_]);
            _loc1_++;
         }
      }
      
      override public function set time(param1:int) : void
      {
         var _loc3_:ParticleAnimator = null;
         var _loc4_:ParticleGroupEventProperty = null;
         var _loc2_:int = param1 - time;
         super.time = param1;
         for each(_loc3_ in this.animators)
         {
            _loc3_.time = time;
         }
         if(this.eventList)
         {
            for each(_loc4_ in this.eventList)
            {
               if(_loc2_ != 0 && (_loc4_.occurTime * 1000 - time) * (_loc4_.occurTime * 1000 - (time - _loc2_)) <= 0)
               {
                  if(hasEventListener(ParticleGroupEvent.OCCUR))
                  {
                     dispatchEvent(new ParticleGroupEvent(ParticleGroupEvent.OCCUR,_loc4_));
                  }
               }
            }
         }
      }
      
      public function resetTime(param1:int = 0) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ParticleAnimator = null;
         while(_loc2_ < this.numAnimator)
         {
            _loc3_ = this.animators[_loc2_];
            _loc3_.resetTime(param1 + this.animatorTimeOffset[_loc2_]);
            _loc2_++;
         }
      }
   }
}

