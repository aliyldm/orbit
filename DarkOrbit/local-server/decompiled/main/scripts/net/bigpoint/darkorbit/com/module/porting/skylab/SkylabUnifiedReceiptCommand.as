package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.*;
   
   public class SkylabUnifiedReceiptCommand implements IModule
   {
      
      private static var _instance:SkylabUnifiedReceiptCommand;
      
      public var construction:String = "";
      
      public var resultId:int = 0;
      
      public var transportPrice:int = 0;
      
      public var robotsLeftTimeList:Vector.<SkylabActiveRobotsLeftTimeCommand>;
      
      public var subaction:String = "";
      
      public var errorId:Vector.<BaseStackCommand>;
      
      public var sucessId:Vector.<BaseStackCommand>;
      
      public function SkylabUnifiedReceiptCommand(param1:String = "", param2:String = "", param3:int = 0, param4:Vector.<BaseStackCommand> = null, param5:Vector.<BaseStackCommand> = null, param6:Vector.<SkylabActiveRobotsLeftTimeCommand> = null, param7:int = 0)
      {
         super();
         this.construction = param2;
         this.resultId = param3;
         this.transportPrice = param7;
         if(param6 == null)
         {
            this.robotsLeftTimeList = new Vector.<SkylabActiveRobotsLeftTimeCommand>();
         }
         else
         {
            this.robotsLeftTimeList = param6;
         }
         this.subaction = param1;
         if(param4 == null)
         {
            this.errorId = new Vector.<BaseStackCommand>();
         }
         else
         {
            this.errorId = param4;
         }
         if(param5 == null)
         {
            this.sucessId = new Vector.<BaseStackCommand>();
         }
         else
         {
            this.sucessId = param5;
         }
      }
      
      public static function get instance() : SkylabUnifiedReceiptCommand
      {
         return _instance || (_instance = new SkylabUnifiedReceiptCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26839;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SkylabActiveRobotsLeftTimeCommand = null;
         var _loc5_:BaseStackCommand = null;
         var _loc6_:BaseStackCommand = null;
         this.construction = param1.readUTF();
         this.resultId = param1.readInt();
         this.resultId = this.resultId << 5 % 32 | this.resultId >>> 32 - 5 % 32;
         this.transportPrice = param1.readInt();
         this.transportPrice = this.transportPrice >>> 12 % 32 | this.transportPrice << 32 - 12 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.robotsLeftTimeList.length > 0)
         {
            this.robotsLeftTimeList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SkylabActiveRobotsLeftTimeCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.robotsLeftTimeList.push(_loc4_);
            _loc2_++;
         }
         this.subaction = param1.readUTF();
         while(this.errorId.length > 0)
         {
            this.errorId.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.errorId.push(_loc5_);
            _loc2_++;
         }
         while(this.sucessId.length > 0)
         {
            this.sucessId.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.sucessId.push(_loc6_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SkylabActiveRobotsLeftTimeCommand = null;
         var _loc3_:BaseStackCommand = null;
         var _loc4_:BaseStackCommand = null;
         param1.writeShort(26839);
         param1.writeUTF(this.construction);
         param1.writeInt(this.resultId >>> 5 % 32 | this.resultId << 32 - 5 % 32);
         param1.writeInt(this.transportPrice << 12 % 32 | this.transportPrice >>> 32 - 12 % 32);
         param1.writeByte(this.robotsLeftTimeList.length);
         for each(_loc2_ in this.robotsLeftTimeList)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.subaction);
         param1.writeByte(this.errorId.length);
         for each(_loc3_ in this.errorId)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.sucessId.length);
         for each(_loc4_ in this.sucessId)
         {
            _loc4_.write(param1);
         }
      }
   }
}

