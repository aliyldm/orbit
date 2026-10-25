package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MessageQueueModule implements IModule
   {
      
      private static var _instance:MessageQueueModule;
      
      public var messageQueue:Vector.<ActivationRequest>;
      
      public function MessageQueueModule(param1:Vector.<ActivationRequest> = null)
      {
         super();
         if(param1 == null)
         {
            this.messageQueue = new Vector.<ActivationRequest>();
         }
         else
         {
            this.messageQueue = param1;
         }
      }
      
      public static function get instance() : MessageQueueModule
      {
         return _instance || (_instance = new MessageQueueModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 249;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ActivationRequest = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.messageQueue.length > 0)
         {
            this.messageQueue.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ActivationRequest(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.messageQueue.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ActivationRequest = null;
         param1.writeShort(249);
         param1.writeByte(this.messageQueue.length);
         for each(_loc2_ in this.messageQueue)
         {
            _loc2_.write(param1);
         }
      }
   }
}

