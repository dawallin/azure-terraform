using BlazorTest.Components;
using Swashbuckle.AspNetCore;

namespace BlazorTest;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.
        builder.Services.AddRazorComponents()
            .AddInteractiveServerComponents();
        
        builder.Services.AddControllers();
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen();
        builder.Services.AddHttpClient();

        var app = builder.Build();

        // Configure the HTTP request pipeline.
        if (!app.Environment.IsDevelopment())
        {
            app.UseExceptionHandler("/Error");
            // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
            app.UseHsts();
        }
        else
        {
            app.UseSwagger();
            app.UseSwaggerUI();
        }

        app.UseHttpsRedirection();
        
         app.UseStaticFiles();
         app.UseAntiforgery();

         app.MapRazorComponents<App>()
             .AddInteractiveServerRenderMode();

        app.MapControllers(); // Map API controllers

        app.MapGet("/test", () => "Hello World!");

        app.Run();
    }
}
