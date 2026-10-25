package net.bigpoint.darkorbit.pattern
{
   public class LaserPattern extends AudibleResourcePattern
   {
      
      public var laserLength:int;
      
      private var absorber:Boolean;
      
      private var speed:Number = 0.15;
      
      public var playLoop:Boolean;
      
      private var playLoopRotated:Boolean;
      
      public var skillResKey:String;
      
      public var ignoreLaserPoints:Boolean;
      
      public var xml:XML;
      
      public var muzzleFlashResKey:String;
      
      public var lightColor:uint;
      
      public var laserType:String;
      
      public var mcWidth:Number = -1;
      
      public var scale:Number = 1;
      
      public function LaserPattern(param1:int, param2:String)
      {
         super(param1,param2);
      }
      
      public function isAbsorber() : Boolean
      {
         return this.absorber;
      }
      
      public function setAbsorber(param1:Boolean) : void
      {
         this.absorber = param1;
      }
      
      public function getSpeed() : Number
      {
         return this.speed;
      }
      
      public function setSpeed(param1:Number) : void
      {
         this.speed = param1;
      }
      
      public function setPlayLoop(param1:Boolean) : void
      {
         this.playLoop = param1;
      }
      
      public function isPlayLoopRotated() : Boolean
      {
         return this.playLoopRotated;
      }
      
      public function setPlayLoopRotated(param1:Boolean) : void
      {
         this.playLoopRotated = param1;
      }
   }
}

