package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIMinimapMarkerCommand implements IModule
   {
      
      private static var _instance:UIMinimapMarkerCommand;
      
      public var id:int = 0;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var maxPing:int = 0;
      
      public var playSound:Boolean = false;
      
      public function UIMinimapMarkerCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:Boolean = false)
      {
         super();
         this.id = param1;
         this.x = param2;
         this.y = param3;
         this.maxPing = param4;
         this.playSound = param5;
      }
      
      public static function get instance() : UIMinimapMarkerCommand
      {
         return _instance || (_instance = new UIMinimapMarkerCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 116;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 17;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.id = param1.readInt();
         this.id = this.id >>> 14 % 32 | this.id << 32 - 14 % 32;
         this.x = param1.readInt();
         this.x = this.x >>> 16 % 32 | this.x << 32 - 16 % 32;
         this.y = param1.readInt();
         this.y = this.y >>> 6 % 32 | this.y << 32 - 6 % 32;
         this.maxPing = param1.readInt();
         this.maxPing = this.maxPing << 2 % 32 | this.maxPing >>> 32 - 2 % 32;
         this.playSound = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(116);
         param1.writeInt(this.id << 14 % 32 | this.id >>> 32 - 14 % 32);
         param1.writeInt(this.x << 16 % 32 | this.x >>> 32 - 16 % 32);
         param1.writeInt(this.y << 6 % 32 | this.y >>> 32 - 6 % 32);
         param1.writeInt(this.maxPing >>> 2 % 32 | this.maxPing << 32 - 2 % 32);
         param1.writeBoolean(this.playSound);
      }
   }
}

