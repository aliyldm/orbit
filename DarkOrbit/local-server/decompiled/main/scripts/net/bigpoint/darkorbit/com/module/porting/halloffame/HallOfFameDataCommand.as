package net.bigpoint.darkorbit.com.module.porting.halloffame
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HallOfFameDataCommand implements IModule
   {
      
      private static var _instance:HallOfFameDataCommand;
      
      public var userId:Number = 0;
      
      public var rank:int = 0;
      
      public var time:String = "";
      
      public var points:Number = 0;
      
      public var value:Number = 0;
      
      public var userName:String = "";
      
      public function HallOfFameDataCommand(param1:Number = 0, param2:String = "", param3:int = 0, param4:String = "", param5:Number = 0, param6:Number = 0)
      {
         super();
         this.userId = param1;
         this.rank = param3;
         this.time = param4;
         this.points = param6;
         this.value = param5;
         this.userName = param2;
      }
      
      public static function get instance() : HallOfFameDataCommand
      {
         return _instance || (_instance = new HallOfFameDataCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 15484;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 32;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userId = param1.readDouble();
         this.rank = param1.readInt();
         this.rank = this.rank >>> 4 % 32 | this.rank << 32 - 4 % 32;
         this.time = param1.readUTF();
         this.points = param1.readDouble();
         this.value = param1.readDouble();
         this.userName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(15484);
         param1.writeDouble(this.userId);
         param1.writeInt(this.rank << 4 % 32 | this.rank >>> 32 - 4 % 32);
         param1.writeUTF(this.time);
         param1.writeDouble(this.points);
         param1.writeDouble(this.value);
         param1.writeUTF(this.userName);
      }
   }
}

