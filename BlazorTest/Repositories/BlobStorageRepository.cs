using Azure.Identity;
using Azure.Storage.Blobs;
using System.Text;
using Azure.Storage.Blobs.Models;

namespace BlazorTest.Repositories;

public class BlobStorageRepository : IBlobStorageRepository
{
    private readonly BlobContainerClient _containerClient;

    public BlobStorageRepository()
    {
        string environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");
        string storageUrl = Environment.GetEnvironmentVariable("STORAGE_URL");
        string blobContainerName = Environment.GetEnvironmentVariable("BLOB_CONTAINER_NAME");

        BlobServiceClient blobServiceClient;
        if (environment == "Development")
        {
            // Use Azurite connection string for local development
            blobServiceClient = new BlobServiceClient(storageUrl);
        }
        else
        {
            // Use Managed Identity for production
            var credential = new DefaultAzureCredential();
            blobServiceClient = new BlobServiceClient(new Uri(storageUrl), credential);
        }

        // Get a reference to a container
        _containerClient = blobServiceClient.GetBlobContainerClient(blobContainerName);

        _containerClient.CreateIfNotExists();
    }

    public async Task SaveAsync(string blobName, string content)
    {
        using var stream = new MemoryStream(Encoding.UTF8.GetBytes(content));
        await SaveAsync(blobName, stream);
    }

    public async Task SaveAsync(string blobName, Stream content)
    {
        // Get a reference to a blob
        BlobClient blobClient = _containerClient.GetBlobClient(blobName);

        // Upload the blob
        await blobClient.UploadAsync(content, overwrite: true);
    }

    public async Task<string> GetAsync(string blobName)
    {
        // Get a reference to a blob
        BlobClient blobClient = _containerClient.GetBlobClient(blobName);

        // Download the blob
        BlobDownloadInfo download = await blobClient.DownloadAsync();

        using (StreamReader reader = new StreamReader(download.Content))
        {
            return await reader.ReadToEndAsync();
        }
    }
}
