package net.bigpoint.darkorbit.com.module.porting.events
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class UpdateEventSummaryScoreCommand implements IModule
   {
      
      private static var _instance:UpdateEventSummaryScoreCommand;
      
      public var eventEnd:Boolean = false;
      
      public var eventType:String = "";
      
      public var scoreCommandList:Vector.<EventSummaryScoreCommand>;
      
      public function UpdateEventSummaryScoreCommand(param1:String = "", param2:Boolean = false, param3:Vector.<EventSummaryScoreCommand> = null)
      {
         super();
         this.eventEnd = param2;
         this.eventType = param1;
         if(param3 == null)
         {
            this.scoreCommandList = new Vector.<EventSummaryScoreCommand>();
         }
         else
         {
            this.scoreCommandList = param3;
         }
      }
      
      public static function get instance() : UpdateEventSummaryScoreCommand
      {
         return _instance || (_instance = new UpdateEventSummaryScoreCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -32546;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 7;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EventSummaryScoreCommand = null;
         this.eventEnd = param1.readBoolean();
         this.eventType = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.scoreCommandList.length > 0)
         {
            this.scoreCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = EventSummaryScoreCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.scoreCommandList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EventSummaryScoreCommand = null;
         param1.writeShort(-32546);
         param1.writeBoolean(this.eventEnd);
         param1.writeUTF(this.eventType);
         param1.writeByte(this.scoreCommandList.length);
         for each(_loc2_ in this.scoreCommandList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

