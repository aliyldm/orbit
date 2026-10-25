package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SoundTriggerModule implements IModule
   {
      
      private static var _instance:SoundTriggerModule;
      
      public var playSound:Boolean = false;
      
      public var soundId:int = 0;
      
      public function SoundTriggerModule(param1:Boolean = false, param2:int = 0)
      {
         super();
         this.playSound = param1;
         this.soundId = param2;
      }
      
      public static function get instance() : SoundTriggerModule
      {
         return _instance || (_instance = new SoundTriggerModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27124;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.playSound = param1.readBoolean();
         this.soundId = param1.readInt();
         this.soundId = this.soundId << 14 % 32 | this.soundId >>> 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(27124);
         param1.writeBoolean(this.playSound);
         param1.writeInt(this.soundId >>> 14 % 32 | this.soundId << 32 - 14 % 32);
      }
   }
}

