package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SpacePlagueCounterDataModule implements IModule
   {
      
      private static var _instance:SpacePlagueCounterDataModule;
      
      public var maxValue:int = 0;
      
      public var active:Boolean = false;
      
      public var currentValue:int = 0;
      
      public function SpacePlagueCounterDataModule(param1:int = 0, param2:int = 0, param3:Boolean = false)
      {
         super();
         this.maxValue = param1;
         this.active = param3;
         this.currentValue = param2;
      }
      
      public static function get instance() : SpacePlagueCounterDataModule
      {
         return _instance || (_instance = new SpacePlagueCounterDataModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -241;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.maxValue = param1.readInt();
         this.maxValue = this.maxValue >>> 13 % 32 | this.maxValue << 32 - 13 % 32;
         this.active = param1.readBoolean();
         this.currentValue = param1.readInt();
         this.currentValue = this.currentValue << 15 % 32 | this.currentValue >>> 32 - 15 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-241);
         param1.writeInt(this.maxValue << 13 % 32 | this.maxValue >>> 32 - 13 % 32);
         param1.writeBoolean(this.active);
         param1.writeInt(this.currentValue >>> 15 % 32 | this.currentValue << 32 - 15 % 32);
      }
   }
}

