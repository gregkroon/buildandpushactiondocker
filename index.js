const core = require('@actions/core');
const exec = require('@actions/exec');

async function run() {
  try {
    // Get inputs
    const username = core.getInput('username');
    const password = core.getInput('password');
    const imageName = core.getInput('image_name');
    const dockerfile = core.getInput('dockerfile');
    const context = core.getInput('context');
    const tags = core.getInput('tags').split(',');

    // Login to Docker Hub
    core.info(`Logging in to Docker Hub as ${username}`);
    await exec.exec(`docker login -u ${username} --password-stdin`, [], {
      input: Buffer.from(password),
    });

    // Build the Docker image
    for (const tag of tags) {
      core.info(`Building Docker image ${imageName}:${tag}`);
      await exec.exec(`docker build -t ${imageName}:${tag} -f ${dockerfile} ${context}`);
    }

    // Push the Docker image
    for (const tag of tags) {
      core.info(`Pushing Docker image ${imageName}:${tag}`);
      await exec.exec(`docker push ${imageName}:${tag}`);
    }

    // Logout from Docker Hub
    core.info('Logging out of Docker Hub');
    await exec.exec('docker logout');
  } catch (error) {
    core.setFailed(`Action failed with error: ${error.message}`);
  }
}

run();
