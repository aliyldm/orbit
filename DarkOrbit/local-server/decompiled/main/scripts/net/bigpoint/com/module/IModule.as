package net.bigpoint.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public interface IModule
   {
      
      function getLibcomModuleId() : int;
      
      function getLibcomModuleEstimatedLength() : int;
      
      function read(param1:IDataInput) : void;
      
      function write(param1:IDataOutput) : void;
   }
}

